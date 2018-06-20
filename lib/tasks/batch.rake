namespace :batch do
  desc "TODO"
  task to_school: :environment do
    users = User.select('id').where(school_year: 2018).where.not(attendance_number: "teacher").pluck(:id)
    today = Date.today
    users.each do |id|
      atnd = Attendance.new(user_id: id, date: today)
      atnd.save
    end
  end

  desc "TODO"
  task from_school: :environment do
    today = Date.today
    atnd = Attendance.where(date: today)
    atnd.each do |atnd|
      atnd.update_attribute(:atnd1, '6') if !atnd['atnd1']
      atnd.update_attribute(:atnd2, '6') if !atnd['atnd2']
      atnd.update_attribute(:atnd3, '6') if !atnd['atnd3']
      atnd.update_attribute(:atnd4, '6') if !atnd['atnd4']
      atnd.update_attribute(:atnd5, '6') if !atnd['atnd5']
    end
  end

end