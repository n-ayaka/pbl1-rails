class AttsController < ApplicationController
  def index
  	#@students = Attendance.joins(:user).select("attendances.*,users.*")
  	@students = Attendance.joins(:user).select("users.*, attendances.*").where(att1: "出席")
  	#render json: @students
  end

  def show
  	@atts = Attendance.joins(:user).select("attendances.*,users.*").where(id: params[:id])
  	# render json: @atts
  end
end
