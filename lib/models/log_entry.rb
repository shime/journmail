require_relative './../init'

class LogEntry < Sequel::Model
  many_to_one :user

  def local_created_at
    created_at.in_time_zone(user.timezone)
  end
end

LogEntry.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
