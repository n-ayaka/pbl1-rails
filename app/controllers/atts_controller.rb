class AttsController < ApplicationController

  # 外部からのPOSTを例外的に許可？みたいな？
  protect_from_forgery :except => [:test]

  # 全員の一ヶ月分(出欠状況管理)
  def atndsAllStudents
    usersSc = User.select('uid, user_id AS attendance_number, user_name').where(school_year: 2018)
    usersSc = usersSc.map{ |u| u.attributes }
    usersCc = Array.new()
    for user in usersSc
      user = user.map{ |k, v| [k.camelize(:lower), v] }.to_h
      usersCc.push(user)
    end

    dates = SchoolDay.select('date').where(school_flag: true, date: (params[:year] + '-' + params[:month] + '-01').to_date.all_month).pluck(:date)

    atndsSc = Attendance.select('att_id, uid AS user_id, date, att1 AS atnd1, att2 AS atnd2, att3 AS atnd3, att4 AS atnd4, att5 AS atnd5, att_time AS came_at, go_back_time AS leaved_at').where(date: (dates[0])..(dates[dates.length - 1]))
    atndsSc = atndsSc.map{ |u| u.attributes }
    atndsCc = Array.new()
    for atnd in atndsSc
      atnd = atnd.map{ |k, v| [k.camelize(:lower), v] }.to_h
      atnd['cameAt'] = atnd['cameAt'].to_time.strftime("%X") if atnd['cameAt']
      atnd['leavedAt'] = atnd['leavedAt'].to_time.strftime("%X") if atnd['leaveAt']
      atndsCc.push(atnd)
    end

    render json: {dates: dates, users: usersCc, atnds: atndsCc}
  end

  # 生徒一人の一ヶ月分(出欠状況詳細)
  def atndsOneStudent
    user = User.select('uid, user_id AS attendance_number, user_name').find_by(school_year: 2018, uid: params[:student]).attributes

    dates = SchoolDay..attributesselect('date').where(school_flag: true, date: (params[:year] + '-' + params[:month] + '-01').to_date.all_month).pluck(:date)

    atndsSc = Attendance.select('date, att1 AS atnd1, att2 AS atnd2, att3 AS atnd3, att4 AS atnd4, att5 AS atnd5, att_time AS came_at, go_back_time AS leaved_at')
                .where(uid: params[:student], date: (dates[0])..(dates[dates.length - 1]))
    atndsSc = atndsSc.map{ |u| u.attributes }
    atndsCc = Array.new()
    atndsSc.each_with_index do |atnd, idx|
      atnd = atnd.map{ |k, v| [k.camelize(:lower), v] }.to_h
      if atnd['date'] != dates[idx]
        atndsSc.insert(idx, Hash.new()) # 添字を増やすため
        atnd = Hash.new()
        atnd['date'] = dates[idx]
      elsif
        atnd['cameAt'] = atnd['cameAt'].to_time.strftime("%X")
        atnd['leavedAt'] = atnd['leavedAt'].to_time.strftime("%X")
      end
      atndsCc.push(atnd)
    end

    # ここから出席率の計算
    yesterday = Date.yesterday.strftime("%Y-%m-%d")

    att = 0     # 出席(就活・公欠を含む)
    absent = 0  # 欠席(病欠・要確認を含む)
    late = 0    # 遅刻

    # 出席
    for num in 1..5 do
      att = att + Attendance.where(uid: params[:student], date: ('2018-04-01')..(yesterday), ('att' + num.to_s) => [0,3,5]).size
    end
    # 欠席
    for num in 1..5 do
      absent = absent + Attendance.where(uid: params[:student], date: ('2018-04-01')..(yesterday), ('att' + num.to_s) => [2,4,6]).size
    end
    # 遅刻
    for num in 1..5 do
      late = late + Attendance.where(uid: params[:student], date: ('2018-04-01')..(yesterday), ('att' + num.to_s) => [1]).size
    end

    # 計算
    percent = ( ((att+late)-(late/3).floor).to_f / (att+absent+late) * 100 ).round(2)


    render json: {id: user['uid'], attendanceNumber: user['attendance_number'], userName: user['user_name'], percent: percent, atnds: atndsCc}
  end

  # 欠席理由変更
  def atndsAttUpdate
    # returnするテキスト
    re_text = 'null'
    # 値が全て取得できたら
    if params[:id] && params[:date] && params[:period] && params[:att]
      # 更新する行を選択
      att = Attendance.select("att_id, uid, date, att1, att2, att3, att4, att5, att_time AS attTime, go_back_time AS goBackTime").find_by(uid: params[:id], date: params[:date])
      # n限目か？
      period = params[:period]
      # periodに応じて、該当するカラムの値を更新
      if period = 1
        att.update_attribute(:att1, params[:att])
        re_text = 'att1 updated'
      elsif period = 2
        att.update_attribute(:att2, params[:att])
        re_text = 'att2 updated'
      elsif period = 3
        att.update_attribute(:att3, params[:att])
        re_text = 'att3 updated'
      elsif period = 4
        att.update_attribute(:att4, params[:att])
        re_text = 'att4 updated'
      elsif period = 5
        att.update_attribute(:att5, params[:att])
        re_text = 'att5 updated'
      else
        re_text = 'att update error'
      end
    else
      re_text = 'get value error'
    end

    # jsonで返す
    render json: re_text
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

