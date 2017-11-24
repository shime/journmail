require "active_support/time"

require_relative "./../init"
require_relative "./../services/streak_calculator"

class User < Sequel::Model
  EMAIL_NOTIFY_AT_HOURS = 18 # notify user by email at 18:00 in their timezone

  STATUSES = {
    paying: 'paying',
    pending: 'pending',
    unsubscribed: 'unsubscribed'
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

  def unsubscribe!
    self.status = STATUSES[:unsubscribed]
    save
  end

  def paying?
    status == STATUSES[:paying]
  end

  def unsubscribed?
    status == STATUSES[:unsubscribed]
  end

  def time_to_send_notification?
    DateTime.now.in_time_zone(timezone).hour == EMAIL_NOTIFY_AT_HOURS
  end

  def streak
    StreakCalculator.call(self)
  end

  def validate
    super
    validates_unique :email
  end
end

User.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
User.plugin :validation_helpers
