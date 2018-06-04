# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(school_year: 2018, user_id: 1, user_name: "元の木阿弥", password: "pw", card_id: "ic1")
User.create!(school_year: 2018, user_id: 2, user_name: "傀儡", password: "pw", card_id: "ic2")

SchoolDay.create!(date: "2018-04-27", school_flag: true)
SchoolDay.create!(date: "2018-04-28", school_flag: false)
SchoolDay.create!(date: "2018-04-29", school_flag: false)
SchoolDay.create!(date: "2018-04-30", school_flag: false)
SchoolDay.create!(date: "2018-05-01", school_flag: true)
SchoolDay.create!(date: "2018-05-02", school_flag: true)
SchoolDay.create!(date: "2018-05-03", school_flag: false)
SchoolDay.create!(date: "2018-05-04", school_flag: false)
SchoolDay.create!(date: "2018-05-05", school_flag: false)
SchoolDay.create!(date: "2018-05-06", school_flag: false)
SchoolDay.create!(date: "2018-05-07", school_flag: true)
SchoolDay.create!(date: "2018-05-08", school_flag: true)
SchoolDay.create!(date: "2018-05-09", school_flag: true)
SchoolDay.create!(date: "2018-05-10", school_flag: true)
SchoolDay.create!(date: "2018-05-11", school_flag: true)
SchoolDay.create!(date: "2018-05-12", school_flag: false)
SchoolDay.create!(date: "2018-05-13", school_flag: false)
SchoolDay.create!(date: "2018-05-14", school_flag: true)
SchoolDay.create!(date: "2018-05-15", school_flag: true)
SchoolDay.create!(date: "2018-05-16", school_flag: true)
SchoolDay.create!(date: "2018-05-17", school_flag: true)
SchoolDay.create!(date: "2018-05-18", school_flag: true)
SchoolDay.create!(date: "2018-05-19", school_flag: false)
SchoolDay.create!(date: "2018-05-20", school_flag: false)
SchoolDay.create!(date: "2018-05-21", school_flag: true)
SchoolDay.create!(date: "2018-05-22", school_flag: true)
SchoolDay.create!(date: "2018-05-23", school_flag: true)
SchoolDay.create!(date: "2018-05-24", school_flag: true)
SchoolDay.create!(date: "2018-05-25", school_flag: true)
SchoolDay.create!(date: "2018-05-26", school_flag: false)
SchoolDay.create!(date: "2018-05-27", school_flag: false)
SchoolDay.create!(date: "2018-05-28", school_flag: true)
SchoolDay.create!(date: "2018-05-29", school_flag: true)
SchoolDay.create!(date: "2018-05-30", school_flag: true)
SchoolDay.create!(date: "2018-05-31", school_flag: true)
SchoolDay.create!(date: "2018-06-01", school_flag: true)

Attendance.create!(uid: 1, date: "2018-04-27", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-01", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-02", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-07", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
#Attendance.create!(uid: 1, date: "2018-05-08", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-09", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-10", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-11", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-14", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-15", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-16", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-17", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-18", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-21", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-22", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-23", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-24", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-25", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-28", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-29", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-30", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-05-31", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 1, date: "2018-06-01", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")

Attendance.create!(uid: 2, date: "2018-04-27", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-01", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-02", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-07", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-08", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-09", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-10", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-11", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-14", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-15", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-16", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-17", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-18", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-21", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-22", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-23", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-24", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-25", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-28", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-29", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-30", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-05-31", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")
Attendance.create!(uid: 2, date: "2018-06-01", att1: 0, att2: 0, att3: 0, att4: 0, att5: 0, att_time: "08:53:11", go_back_time: "15:02:23")


SchoolDay.create!(date: "2018-06-04", school_flag: true)
Attendance.create!(uid: 1, date: "2018-06-04")
Attendance.create!(uid: 2, date: "2018-06-04", att_time: "10:25:11", att1: 2, att2: 1)