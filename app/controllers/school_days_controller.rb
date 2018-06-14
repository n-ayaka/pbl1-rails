require "holiday_jp"

class SchoolDaysController < ApplicationController
  protect_from_forgery :except => [:add]
  def add

    dates = [*(((params[:fiscalYear] + '-04-01').to_date)..(((params[:fiscalYear].to_i + 1).to_s + '-04-01').to_date)).to_a]
              .map{ |date, bool| [date, (
                (params[:firstTermStartDate].to_date <= date && date <= params[:firstTermLastDate].to_date) ||
                (params[:latterTermStartDate].to_date <= date && date <= params[:latterTermLastDate].to_date)
              )] }.to_h
              .map{ |date, bool| [date, ( bool && !(date.wday == 0 || date.wday == 6) )] }.to_h
              .map{ |date, bool| [date, ( bool && !(HolidayJp.holiday?(date)) )] }.to_h

    if SchoolDay.first.blank?
      dates.each do |date, bool|
        day = SchoolDay.new(date: date, school_flag: bool)
        day.save
      end
    else
      dates.each{ |date, bool| SchoolDay.where(date: date).update(school_flag: bool) }
    end

  end
end
