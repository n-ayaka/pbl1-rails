class AttsController < ApplicationController

  # 外部からのPOSTを例外的に許可？みたいな？
  protect_from_forgery :except => [:getTougekouRecord]
  protect_from_forgery :except => [:test]

  # 全員の一ヶ月分
  def atnds_all_students
    usersSc = User.select('id, attendance_number, user_name').where(school_year: 2018).where.not(attendance_number: "teacher")
    usersSc = usersSc.map{ |u| u.attributes }
    usersCc = Array.new()
    for user in usersSc
      user = user.map{ |k, v| [k.camelize(:lower), v] }.to_h
      usersCc.push(user)
    end

    dates = SchoolDay.select('date').where(school_flag: true, date: (params[:year] + '-' + params[:month] + '-01').to_date.all_month).pluck(:date)

    atndsSc = Attendance.select('id, user_id, date, atnd1, atnd2, atnd3, atnd4, atnd5, come_at, left_at')
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
    user = User.select('id, attendance_number, user_name').find_by(school_year: 2018, id: params[:student]).attributes

    dates = SchoolDay.select('date').where(school_flag: true, date: (params[:year] + '-' + params[:month] + '-01').to_date.all_month).pluck(:date)

    atndsSc = Attendance.select('id, user_id, date, atnd1, atnd2, atnd3, atnd4, atnd5, come_at, left_at')
                .where(user_id: params[:student], date: (dates[0])..(dates[dates.length - 1])).order('date asc')
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
    atnd = Attendance.select('id, user_id, date, atnd1, atnd2, atnd3, atnd4, atnd5, come_at, left_at').find_by(user_id: params[:student], date: params[:date])
    if atnd == nil
      atnd = Attendance.new(user_id: params[:student], date: params[:date], atnd1: 6, atnd2: 6, atnd3: 6, atnd4: 6, atnd5: 6)
      atnd.save
    end
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

    # 該当するICカードの番号があるかチェック
    if User.find_by(card_id: params[:cid], school_year: 2018) == nil
      render plain: '該当するカード番号がDBに登録されていません'
    else
      # 受け取ったカードの固有ID(cid)と日付(today)から該当するAttendanceテーブルの行を選択
      atnd = Attendance.joins(:user).select('attendances.id AS att_id, come_at, left_at, users.id').where('attendances.date' => today, 'users.card_id' => params[:cid], 'users.school_year' => 2018).first.attributes
      # 登校時刻・下校時刻の有無から、何回目のICカードタッチか判断する
      if atnd['come_at'] then
        if atnd['left_at'] then
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
  end

  # 1回目のICカードタッチ
  def tougekouUpdate1(att_id,time)
    atnd = Attendance.find_by(id: att_id)
    atnd.update_attribute(:come_at, time)

    # timeに応じてatnd1~5の該当するものをupdate
    if time < '09:20:00'
      text = '遅刻欠席なし'
    elsif time < '09:35:00'
      text = '1限目遅刻'
      atnd.update_attribute(:atnd1, '1')
    elsif time < '10:20:00'
      text = '1限目欠席'
      atnd.update_attribute(:atnd1, '6')
    elsif time < '10:35:00'
      text = '1限目欠席/2限目遅刻'
      atnd.update_attributes(atnd1: '6', atnd2: '1')
    elsif time < '11:20:00'
      text = '1限目欠席/2限目欠席'
      atnd.update_attributes(atnd1: '6', atnd2: '6')
    elsif time < '11:35:00'
      text = '1,2限目欠席/3限目遅刻'
      atnd.update_attributes(atnd1: '6', atnd2: '6', atnd3: '1')
    elsif time < '13:00:00'
      text = '1,2限目欠席/3限目欠席'
      atnd.update_attributes(atnd1: '6', atnd2: '6', atnd3: '6')
    elsif time < '13:15:00'
      text = '1,2,3限目欠席/4限目遅刻'
      atnd.update_attributes(atnd1: '6', atnd2: '6', atnd3: '6', atnd4: '1')
    elsif time < '14:00:00'
      text = '1,2,3限目欠席/4限目欠席'
      atnd.update_attributes(atnd1: '6', atnd2: '6', atnd3: '6', atnd4: '6')
    elsif time < '14:15:00'
      text = '1,2,3,4限目欠席/5限目遅刻'
      atnd.update_attributes(atnd1: '6', atnd2: '6', atnd3: '6', atnd4: '6', atnd5: '1')
    else
      text = '1,2,3,4限目欠席/5限目欠席'
      atnd.update_attributes(atnd1: '6', atnd2: '6', atnd3: '6', atnd4: '6', atnd5: '6')
    end

    render plain: '1回目のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s + ' text:' + text.to_s
  end

  # 2回目のICカードタッチ
  def tougekouUpdate2(att_id,time)
    atnd = Attendance.find_by(id: att_id)
    atnd.update_attribute(:left_at, time)

    # timeに応じてatnd1~5の該当するものをupdate
    if time >= '14:50:00'
      text = '5限目終了後に下校'
    elsif time >= '13:50'
      text = '4限終了後or5限目中に下校'
      atnd.update_attributes(atnd5: '6')
    elsif time >= '12:00'
      text = 'お昼or4限目中に下校'
      atnd.update_attributes(atnd4: '6', atnd5: '6')
    elsif time >= '11:10'
      text = '2限終了後or3限目中に下校'
      atnd.update_attributes(atnd3: '6', atnd4: '6', atnd5: '6')
    elsif time >= '10:10'
      text = '1限終了後or2限目中に下校'
      atnd.update_attributes(atnd2: '6', atnd3: '6', atnd4: '6', atnd5: '6')
    else
      text = '1限目中orそれより前に下校'
      atnd.update_attributes(atnd1: '6', atnd2: '6', atnd3: '6', atnd4: '6', atnd5: '6')
    end

    # nilになってるところを0に
    atnd.update_attribute(:atnd1, '0') if !atnd['atnd1']
    atnd.update_attribute(:atnd2, '0') if !atnd['atnd2']
    atnd.update_attribute(:atnd3, '0') if !atnd['atnd3']
    atnd.update_attribute(:atnd4, '0') if !atnd['atnd4']
    atnd.update_attribute(:atnd5, '0') if !atnd['atnd5']

    render plain: '2回目のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s + ' text:' + text.to_s
  end

  # 3回目以降のICカードタッチ
  def tougekouUpdate3(att_id,time)
    atnd = Attendance.find_by(id: att_id)
    atnd.update_attribute(:left_at, time)
    render plain: '3回目以降のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s
  end

end

