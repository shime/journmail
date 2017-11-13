require "active_support/time"
require_relative "./../init"

class User < Sequel::Model
  one_to_many :log_entries

  def paying?
    status == 'paying'
  end

  def time_to_send_notification?
    DateTime.now.in_time_zone(timezone).hour == 20
  end
end

User.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
