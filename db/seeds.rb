# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"

# テスト用Userテーブルデータ登録
CSV.foreach('db/user.csv', {skip_blanks: true, encoding: "SJIS"}) do |row|
  User.create(:school_year => row[0], :attendance_number => row[1], :user_name => row[2], :password => row[3], :card_id => row[4])
end


# テスト用Attendanceテーブルデータ登録
apr = ['11','12','13','16','17','18','19','20','23','24','25','26','27','30']
may = ['01','02','07','08','09','10','11','14','15','16','17','18','21','22','23','24','25','28','29','30','31']
jun = ['04','05','06','07','08','11','12','13','14','15','18']

15.times do |id|
  # 4月
  apr.each do |apr|
    Attendance.create!(user_id: "#{id+1}", date: "2018-04-"+apr, atnd1: 0, atnd2: 0, atnd3: 0, atnd4: 0, atnd5: 0, come_at: "08:53:11", left_at: "15:02:23")
  end
  # 5月
  may.each do |may|
    Attendance.create!(user_id: "#{id+1}", date: "2018-05-"+may, atnd1: 0, atnd2: 0, atnd3: 0, atnd4: 0, atnd5: 0, come_at: "08:53:11", left_at: "15:02:23")
  end
  # 6月
  jun.each do |jun|
    Attendance.create!(user_id: "#{id+1}", date: "2018-06-"+jun, atnd1: 0, atnd2: 0, atnd3: 0, atnd4: 0, atnd5: 0, come_at: "08:53:11", left_at: "15:02:23")
  end

end

