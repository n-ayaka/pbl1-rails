require "holiday_jp"

class SchoolDaysController < ApplicationController
  def add

    dates = [*(((params[:fiscalYear] + '-04-01').to_date)..(((params[:fiscalYear].to_i + 1).to_s + '-04-01').to_date)).to_a]
              .map{ |date, bool| [date, (
                (params[:firstTermStartDate].to_date <= date && date <= params[:firstTermLastDate].to_date) ||
                (params[:latterTermStartDate].to_date <= date && date <= params[:latterTermLastDate].to_date)
              )] }.to_h
              .map{ |date, bool| [date, ( bool && !(date.wday == 0 || date.wday == 6) )] }.to_h
              .map{ |date, bool| [date, ( bool && !(HolidayJp.holiday?(date)) )] }.to_h

    if Day.first.blank?
      dates.each do |date, bool|
        day = Day.new(date: date, school_flag: bool)
        day.save
      end
    else
      dates.each{ |date, bool| Day.where(date: date).update(school_flag: bool) }
    end

  end
end
