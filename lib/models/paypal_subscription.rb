require_relative './../init'

class PaypalSubscription < Sequel::Model
  one_to_one :user

  STATUSES = {
    active: "active",
    pending: "pending",
    unsubscribed: "unsubscribed"
  }

  def active?
    status == STATUSES[:active]
  end

  def unsubscribe!
    self.status = STATUSES[:unsubscribed]
    save
  end
end

PaypalSubscription.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
