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
#
env :MAILTO, ""
env :PATH, ENV['PATH']
env :POSTMARK_API_TOKEN, ENV["POSTMARK_API_TOKEN"]
set :output, File.join(File.dirname(__FILE__), "../logs/cron.log")
set :environment_variable, "RACK_ENV"

every 1.hour do
  script "email_notifier"
end
