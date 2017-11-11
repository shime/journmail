require_relative './../init'

class LogEntry < Sequel::Model
  many_to_one :user
end

LogEntry.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
