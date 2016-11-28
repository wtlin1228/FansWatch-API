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