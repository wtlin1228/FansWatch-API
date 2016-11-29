# frozen_string_literal: true
require 'rake/testtask'

task :default do
  puts `rake -T`
end

# task for running multiple testing files
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

namespace :db do
  task :_setup do
    require 'sequel'
    require_relative 'init'
    Sequel.extension :migration
  end

  desc 'Run database migrations'
  task migrate: [:_setup] do
    puts "Migrating to latest for: #{ENV['RACK_ENV'] || 'development'}"
    Sequel::Migrator.run(DB, 'db/migrations')
  end

  desc 'Reset migrations (full rollback and migration)'
  task reset: [:_setup] do
    Sequel::Migrator.run(DB, 'db/migrations', target: 0)
    Sequel::Migrator.run(DB, 'db/migrations')
  end
end