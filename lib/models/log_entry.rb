require_relative './../init'
require 'spreadsheet_architect'

class LogEntry < Sequel::Model
  include SpreadsheetArchitect
  many_to_one :user

  def local_created_at
    created_at.in_time_zone(user.timezone)
  end

  def spreadsheet_columns
    [
      ['Created at', :created_at],
      ['Body', :body]
    ]
  end
end

LogEntry.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
