require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'config'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

namespace :db do
  require "sequel"
  Sequel.extension :migration
  Config.load_and_set_settings(Config.setting_files("./config", ENV['RACK_ENV']))

  begin
    DB = Sequel.connect(Settings.urls.db)
  rescue
    puts "Can't connect to 'one_sentence_per_day' - create it first?"
  end

  desc "Creates database"
  task :create do
    Config.load_and_set_settings(Config.setting_files("./config", ENV['RACK_ENV']))
    ROOT_DB = Sequel.connect("postgres://localhost:5432/postgres")
    ROOT_DB.execute "CREATE DATABASE #{Settings.urls.db.split('/')[-1]}"
  end

  desc "Prints current schema version"
  task :version do
    version = if DB.tables.include?(:schema_info)
                DB[:schema_info].first[:version]
              end || 0

              puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DB, "db/migrations")
    Rake::Task['db:version'].execute
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DB, "db/migrations", :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DB, "db/migrations", :target => 0)
    Sequel::Migrator.run(DB, "db/migrations")
    Rake::Task['db:version'].execute
  end
end

task :default => :features
