class AttsController < ApplicationController
  def index
  	# render json:はどちらかコメントアウトしてください
  	search_date = '2018-05-01'
  	users = User.select("id, user_id AS userId, user_name AS userName").where(school_year: 2018)
  	dates = SchoolDay.where(school_flag: true, date: search_date.in_time_zone.all_month).select("date").limit(5).pluck(:date)
  	atnds = Attendance.where(date: search_date.in_time_zone.all_month).select("att_id AS attId, id, date, att1, att2, att3, att4, att5, att_time AS attTime, go_back_time AS goBackTime")
  	# ネストされた構造になってはいるが、key名とかattendancesテーブル全件表示とかされちゃうやつ
  	render json: {users: users.as_json(:include => {:attendances => {:except => [:att_id, :id]}}), dates: dates}

  	atnds = []
  	users.each do |ids|
  		atnds.push(Attendance.includes(:user).select("id, date, att1, att2, att3, att4, att5, att_time AS attTime, go_back_time AS goBackTime").where(id: ids).limit(5))
  	end
  	# attendances(atnds)は希望通りの抽出になるが、users情報がくっつけられない
  	render json: {atnds: atnds, dates: dates}

  end

  def show
  	if params[:id] && params[:date] && params[:period] && params[:att]
  		att = Attendance.find_by(id: params[:id], date: params[:date])
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
  	@atts = Attendance.joins(:user).select("attendances.*,users.id,users.user_id,users.user_name").where(id: params[:id])
  	render json: @atts 
  end

end
