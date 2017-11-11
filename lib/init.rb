require 'config'
require 'sequel'
require 'pry'

ENV['RACK_ENV'] ||= 'development'

Config.load_and_set_settings(Config.setting_files("./config", ENV['RACK_ENV']))
Sequel.connect(Settings.urls.db)
