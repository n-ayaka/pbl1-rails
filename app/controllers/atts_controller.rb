class AttsController < ApplicationController
  def index
    # 取得する最初の日付
    search_day = '2018-05-01'
    # search dayの月末を取得
    # end of monthを使うために一度Date型にparse -> その後string型にparse
    eom_day = (Date.parse(search_day).end_of_month).strftime
    # 今年度
    s_year = '2018'

    # 今年度の学生を取得
    users = User.select("uid, user_id AS userId, user_name AS userName").where(school_year: s_year)
    # 登校日を5件取得
    dates = SchoolDay.where(school_flag: true, date: search_day..eom_day).select("date").limit(5).pluck(:date)

    # sday:取得した登校日の1件目、lday:取得した登校日の5件目
    sday = dates[0]
    lday = dates[4]

    # 学生ごとに出欠状況を5件ずつ取得
    atnds = []
    users.each do |ids|
      atnds.push(Attendance.includes(:user).select("att_id, uid, date, att1, att2, att3, att4, att5, att_time AS attTime, go_back_time AS goBackTime").where(uid: ids, date: sday..lday).limit(5))
    end

    # jsonで返す
    render json: {users: users, atnds: atnds, dates: dates}
  end


  def show
    # 取得する月の日付(何日でもOK)
    search_day = '2018-05-01'

    # ユーザーID(:id)から学生名を取得
    users = User.select("uid, user_id AS userId, user_name AS userName").where(uid: params[:id])

    # 学生個人の出欠状況を月すべて取得
    atnds = Attendance.select("att_id, uid, date, att1, att2, att3, att4, att5, att_time AS attTime, go_back_time AS goBackTime").where(uid: params[:id], date: search_day.in_time_zone.all_month)

    # jsonで返す
    render json: {users: users, atnds: atnds}
  end

=begin
    if params[:id] && params[:date] && params[:period] && params[:att]
      att = Attendance.find_by(uid: params[:id], date: params[:date]).select("att_id, uid, date, att1, att2, att3, att4, att5, att_time AS attTime, go_back_time AS goBackTime")
      period = params[:period]
      if period = 1
        att.update_attribute(:att1, params[:att])
      elsif period = 2
        att.update_attribute(:att2, params[:att])
      elsif period = 3
        att.update_attribute(:att3, params[:att])
      elsif period = 4
        att.update_attribute(:att4, params[:att])
      elsif period = 5
        att.update_attribute(:att5, params[:att])
      end
    end
=end

  def change
  end

end