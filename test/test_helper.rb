# frozen_string_literal: true
ENV['RACK_ENV'] = 'development'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require './init.rb'

include Rack::Test::Methods

def app
  FansWatchAPI
end

if File.file?('config/app.yml')
  credentials = YAML.load(File.read('config/app.yml'))
  ENV['FB_CLIENT_ID'] = credentials['development']['FB_CLIENT_ID']
  ENV['FB_CLIENT_SECRET'] = credentials['development']['FB_CLIENT_SECRET']
  ENV['FB_ACCESS_TOKEN'] = credentials['development']['FB_ACCESS_TOKEN']
  ENV['FB_PAGE_ID'] = credentials['development']['FB_PAGE_ID']
end




PAGE_URL_1 = 'https://www.facebook.com/cyberbuzz'
PAGE_URL_2 = 'https://www.facebook.com/time'
PAGE_URL_3 = 'https://www.facebook.com/cnn'
