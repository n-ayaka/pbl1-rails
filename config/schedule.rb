# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, 'log/cron.log'
set :environment, :development
env :PATH, ENV['PATH']

# 一日のはじめにinsert
every 1.day, at: '7:00 am' do
  rake "batch:to_school"
end

# 一日のおわりにnil->6
every 1.day, at: '7:00 pm' do
  rake "batch:from_school"
end

# 自動バックアップ(一応、週1フルバックアップ)
every :friday, at: '7:05 pm' do
  rake "backup:dump_all"
end