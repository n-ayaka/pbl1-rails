class AttsController < ApplicationController

  # 外部からのPOSTを例外的に許可？みたいな？
  protect_from_forgery :except => [:test]

  # 全員の一ヶ月分
  def atnds_all_students
    usersSc = User.select('uid, user_id AS attendance_number, user_name').where(school_year: 2018)
    usersSc = usersSc.map{ |u| u.attributes }
    usersCc = Array.new()
    for user in usersSc
      user = user.map{ |k, v| [k.camelize(:lower), v] }.to_h
      usersCc.push(user)
    end

    dates = SchoolDay.select('date').where(school_flag: true, date: (params[:year] + '-' + params[:month] + '-01').to_date.all_month).pluck(:date)

    atndsSc = Attendance.select('att_id, uid AS user_id, date, att1 AS atnd1, att2 AS atnd2, att3 AS atnd3, att4 AS atnd4, att5 AS atnd5, att_time AS come_at, go_back_time AS left_at')
                .where(date: (dates[0])..(dates[dates.length - 1])).order('date ASC')
    atndsSc = atndsSc.map{ |u| u.attributes }
    atndsCc = Array.new()
    for atnd in atndsSc
      atnd = atnd.map{ |k, v| [k.camelize(:lower), v] }.to_h
      unless atnd['comeAt'].blank?
        atnd['comeAt'] = atnd['comeAt'].to_time.strftime("%X")
      end
      unless atnd['leftAt'].blank?
        atnd['leftAt'] = atnd['leftAt'].to_time.strftime("%X")
      end
      atndsCc.push(atnd)
    end

    render json: {dates: dates, users: usersCc, atnds: atndsCc}
  end

  # 生徒一人の一ヶ月分
  def atnds_one_student
    user = User.select('uid, user_id AS attendance_number, user_name').find_by(school_year: 2018, uid: params[:student]).attributes

    dates = SchoolDay.select('date').where(school_flag: true, date: (params[:year] + '-' + params[:month] + '-01').to_date.all_month).pluck(:date)

    atndsSc = Attendance.select('att_id, date, att1 AS atnd1, att2 AS atnd2, att3 AS atnd3, att4 AS atnd4, att5 AS atnd5, att_time AS come_at, go_back_time AS left_at')
                .where(uid: params[:student], date: (dates[0])..(dates[dates.length - 1])).order('date asc')
    atndsSc = atndsSc.map{ |u| u.attributes }
    atndsCc = Array.new()
    atndsSc.each_with_index do |atnd, idx|
      atnd = atnd.map{ |k, v| [k.camelize(:lower), v] }.to_h
      if atnd['date'] != dates[idx]
        atndsSc.insert(idx, Hash.new())
        atnd = Hash.new()
        atnd['date'] = dates[idx]
        atnd['atnd1'], atnd['atnd2'], atnd['atnd3'], atnd['atnd4'], atnd['atnd5'] = 6, 6, 6, 6, 6;
      elsif
        unless atnd['comeAt'].blank?
          atnd['comeAt'] = atnd['comeAt'].to_time.strftime("%X")
        end
        unless atnd['leftAt'].blank?
          atnd['leftAt'] = atnd['leftAt'].to_time.strftime("%X")
        end
      end
      atndsCc.push(atnd)
    end

    render json: {id: user['id'], attendanceNumber: user['attendance_number'], userName: user['user_name'], atnds: atndsCc}
  end

  # 出席状況の更新
  def update_attendance
    state = JSON.parse(request.body.read).to_a
    atnd = Attendance.find_by(uid: params[:student], date: params[:date]).select('att_id, uid, date, att1 AS atnd1, att2 AS atnd2, att3 AS atnd3, att4 AS atnd4, att5 AS atnd5, att_time AS come_at, go_back_time AS left_at')
    atnd.update(state[0][0] => state[0][1])

    startAts = Array.new()
    startAts[0], startAts[1], startAts[2], startAts[3], startAts[4] \
      = '09:20:00'.to_time, '10:20:00'.to_time, '11:20:00'.to_time, '13:00:00'.to_time, '14:00:00'.to_time
    states = Array.new()
    states[0], states[1], states[2], states[3], states[4] = atnd['atnd1'], atnd['atnd2'], atnd['atnd3'], atnd['atnd4'], atnd['atnd5']

    # 登校時刻の更新
    states.each_with_index do |state, idx|
      case state
      when 0
        atnd['come_at'] = startAts[idx].strftime("%X")
        break
      when 1
        atnd['come_at'] = (startAts[idx] + (60*15)).strftime("%X")
        break
      end
    end

    # 下校時刻の更新
    states.each_with_index.reverse_each do |state, idx|
      if state == 0 || state == 1
        atnd['left_at'] = (startAts[idx] + (60*50)).strftime("%X")
        break
      end
    end

    atnd.update(come_at: atnd['come_at'], left_at: atnd['left_at'])
    render json: {comeAt: atnd['come_at'].strftime("%X"), leftAt: atnd['left_at'].strftime("%X")}
  end

  # カードの固有IDを取得
  def getTougekouRecord
    # 今日の日付、現在時刻を取得
    today = Date.today.strftime("%Y-%m-%d")
    time = Time.now.strftime("%H:%M:%S")

    # 受け取ったカードの固有ID(cid)と日付(today)から該当するAttendanceテーブルの行を選択
    atnd = Attendance.joins(:user).select('attendances.att_id,  att_time AS came_at, go_back_time AS leaved_at, users.uid').where('attendances.date' => today, 'users.card_id' => params[:cid]).first.attributes

    if atnd['came_at'] then
      if atnd['leaved_at'] then
        # 3回目以降のICカードタッチ
        tougekouUpdate3(atnd['att_id'], time)
      else
        # 2回目のICカードタッチ
        tougekouUpdate2(atnd['att_id'], time)
      end
    else
      # 1回目のICカードタッチ
      tougekouUpdate1(atnd['att_id'], time)
    end

  end

  # 1回目のICカードタッチ
  def tougekouUpdate1(att_id,time)
    atnd = Attendance.find_by(att_id: att_id)
    atnd.update_attribute(:att_time, time)

    # timeに応じてatt1~5の該当するものをupdate
    if time < '09:20:00'
      text = '遅刻欠席なし'
    elsif time < '09:35:00'
      text = '1限目遅刻'
      atnd.update_attribute(:att1, '1')
    elsif time < '10:20:00'
      text = '1限目欠席'
      atnd.update_attribute(:att1, '6')
    elsif time < '10:35:00'
      text = '1限目欠席/2限目遅刻'
      atnd.update_attributes(att1: '6', att2: '1')
    elsif time < '11:20:00'
      text = '1限目欠席/2限目欠席'
      atnd.update_attributes(att1: '6', att2: '6')
    elsif time < '11:35:00'
      text = '1,2限目欠席/3限目遅刻'
      atnd.update_attributes(att1: '6', att2: '6', att3: '1')
    elsif time < '13:00:00'
      text = '1,2限目欠席/3限目欠席'
      atnd.update_attributes(att1: '6', att2: '6', att3: '6')
    elsif time < '13:15:00'
      text = '1,2,3限目欠席/4限目遅刻'
      atnd.update_attributes(att1: '6', att2: '6', att3: '6', att4: '1')
    elsif time < '14:00:00'
      text = '1,2,3限目欠席/4限目欠席'
      atnd.update_attributes(att1: '6', att2: '6', att3: '6', att4: '6')
    elsif time < '14:15:00'
      text = '1,2,3,4限目欠席/5限目遅刻'
      atnd.update_attributes(att1: '6', att2: '6', att3: '6', att4: '6', att5: '1')
    else
      text = '1,2,3,4限目欠席/5限目欠席'
      atnd.update_attributes(att1: '6', att2: '6', att3: '6', att4: '6', att5: '6')
    end

    render plain: '1回目のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s + ' text:' + text.to_s
  end

  # 2回目のICカードタッチ
  def tougekouUpdate2(att_id,time)
    atnd = Attendance.find_by(att_id: att_id)
    atnd.update_attribute(:go_back_time, time)

    # timeに応じてatt1~5の該当するものをupdate
    if time >= '14:50:00'
      text = '5限目終了後に下校'
    elsif time >= '13:50'
      text = '4限終了後or5限目中に下校'
      atnd.update_attributes(att5: '6')
    elsif time >= '12:00'
      text = 'お昼or4限目中に下校'
      atnd.update_attributes(att4: '6', att5: '6')
    elsif time >= '11:10'
      text = '2限終了後or3限目中に下校'
      atnd.update_attributes(att3: '6', att4: '6', att5: '6')
    elsif time >= '10:10'
      text = '1限終了後or2限目中に下校'
      atnd.update_attributes(att2: '6', att3: '6', att4: '6', att5: '6')
    else
      text = '1限目中orそれより前に下校'
      atnd.update_attributes(att1: '6', att2: '6', att3: '6', att4: '6', att5: '6')
    end

    # nilになってるところを0に
    atnd.update_attribute(:att1, '0') if !atnd['att1']
    atnd.update_attribute(:att2, '0') if !atnd['att2']
    atnd.update_attribute(:att3, '0') if !atnd['att3']
    atnd.update_attribute(:att4, '0') if !atnd['att4']
    atnd.update_attribute(:att5, '0') if !atnd['att5']

    render plain: '2回目のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s + ' text:' + text.to_s
  end

  # 3回目以降のICカードタッチ
  def tougekouUpdate3(att_id,time)
    atnd = Attendance.find_by(att_id: att_id)
    atnd.update_attribute(:go_back_time, time)
    render plain: '3回目以降のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s
  end


  # pyton -> railsへのtest
  def test
    user = User.find_by(uid: 1)
    user.update_attribute(:card_id, params[:cid])
    render json: params[:cid]
  end

end

