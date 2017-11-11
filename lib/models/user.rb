require_relative './../init'

class User < Sequel::Model
  one_to_many :log_entries

  def paying?
    status == 'paying'
  end
end

User.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
