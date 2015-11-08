# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :parser do
  desc "Parse all content and store into database"
  task :parse_all do
    ParsersSchedule.new.fetch_all
  end
end
