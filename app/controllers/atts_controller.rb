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
      atnd['cameAt'] = atnd['cameAt'].to_time.strftime("%X")
      atnd['leavedAt'] = atnd['leavedAt'].to_time.strftime("%X")
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

  # カードの固有IDと時間・写真のファイル名を取得
  def getTougekouRecord
    today = Date.today.strftime("%Y-%m-%d")

    atnd = Attendance.joins(:user).select('attendances.att_id,  att_time AS came_at, go_back_time AS leaved_at, users.uid').where('attendances.date' => today, 'users.card_id' => params[:cid]).first.attributes

    if atnd['came_at'] then
      if atnd['leaved_at'] then
        #3回目
        tougekouUpdate3(atnd['att_id'], params[:time])
      else
        #2回目
        tougekouUpdate2(atnd['att_id'], params[:time])
      end
    else
      #1回目
      tougekouUpdate1(atnd['att_id'], params[:time])
    end

  end

  # 1回目のICカードタッチ
  def tougekouUpdate1(att_id,time)
    # todo
    render plain: '1回目のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s
  end

  # 2回目のICカードタッチ
  def tougekouUpdate2(att_id,time)
    # todo
    render plain: '2回目のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s
  end

  # 3回目以降のICカードタッチ
  def tougekouUpdate3(att_id,time)
    # todo
    render plain: '3回目以降のICカードタッチ * att_id:'+ att_id.to_s + ', time:' + time.to_s
  end


  # pyton -> railsへのtest
  def test
    user = User.find_by(uid: 1)
    user.update_attribute(:card_id, params[:cid])
    render json: params[:cid]
  end

end

