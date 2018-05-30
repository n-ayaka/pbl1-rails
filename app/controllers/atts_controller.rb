class AttsController < ApplicationController

  # 全員の一ヶ月分
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

  # 生徒一人の一ヶ月分
  def atndsOneStudent
    user = User.select('uid, user_id AS attendance_number, user_name').find_by(school_year: 2018, uid: params[:student]).attributes

    dates = SchoolDay.select('date').where(school_flag: true, date: (params[:year] + '-' + params[:month] + '-01').to_date.all_month).pluck(:date)

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

    render json: {id: user['uid'], attendanceNumber: user['attendance_number'], userName: user['user_name'], atnds: atndsCc}
  end


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

end