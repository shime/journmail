require 'sequel'
DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost:5432/one_sentence_per_day')

class User < Sequel::Model
  def paying?
    status == 'paying'
  end
end

User.plugin :timestamps, create: :created_at, update: :updated_at, update_on_create: true
