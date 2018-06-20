require 'active_record'

namespace :backup do
  desc "DB[BPBL1] full backup"
  task dump_all: :environment do
    cmd = nil
    environment = Rails.env
    configuration = ActiveRecord::Base.configurations[environment]
    cmd = "mysqldump -u #{configuration['username']} -p#{configuration['password']} #{configuration['database']} > db/#{configuration['database']}.dump"
    puts cmd
    exec cmd
  end

  desc "DB[BPBL1] restore"
  task restore: :environment do
    cmd = nil
    environment = Rails.env
    configuration = ActiveRecord::Base.configurations[environment]
    cmd = "mysql -u #{configuration['username']} -p#{configuration['password']} #{configuration['database']} < db/#{configuration['database']}.dump"
    puts cmd
    exec cmd
  end

end