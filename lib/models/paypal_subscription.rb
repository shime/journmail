require_relative './../init'

class PaypalSubscription < Sequel::Model
  one_to_one :user
end

PaypalSubscription.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
