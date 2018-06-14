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

  desc "TODO"
  task test: :environment do
    today = Date.today
    Attendance.where(date: today).update_all(come_at: '09:10:00')
    Attendance.where(user_id: '1', date: today).update_all(atnd1: '0', atnd2: '0', atnd3: '0', atnd4: '0', atnd5: '0', left_at: '14:50:00')
    Attendance.where(user_id: '2', date: today).update_all(come_at: '09:22:00', atnd1: '1')
  end

end