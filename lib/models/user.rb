require "active_support/time"
require_relative "./../init"
require_relative "log_entry"

class User < Sequel::Model
  EMAIL_NOTIFY_AT_HOURS = 18 # notify user by email at 18:00 in their timezone

  STATUSES = {
    paying: 'paying',
    pending: 'pending'
  }

  one_to_many :log_entries

  def self.paying
    where(status: STATUSES[:paying])
  end

  def self.pending
    where(status: STATUSES[:pending])
  end

  def make_paying!
    self.status = STATUSES[:paying]
    save
  end

  def paying?
    status == STATUSES[:paying]
  end

  def time_to_send_notification?
    DateTime.now.in_time_zone(timezone).hour == EMAIL_NOTIFY_AT_HOURS
  end

  def streak
    days = LogEntry.where(user_id: id).order{created_at.desc}.select(:created_at).map {|row|
      row.values
    }.map {|value| value[:created_at].to_date}

    first_day_in_collection_is_today_or_yesterday = (days.first == Date.current || days.first == Date.current.yesterday)
    streak = first_day_in_collection_is_today_or_yesterday ? 1 : 0
    days.each_with_index do |day, index|
      break unless first_day_in_collection_is_today_or_yesterday
      if days[index + 1] == day.yesterday
        streak += 1
      else
        break
      end
    end
    streak
  end

end

User.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
