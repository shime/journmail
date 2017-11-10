require 'sequel'
DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost:5432/one_sentence_per_day')

class User < Sequel::Model
end
