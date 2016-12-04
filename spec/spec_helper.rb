# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require './init.rb'

# require_relative '../app'

include Rack::Test::Methods

def app
  FansWatchAPI
end

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
PAGES_CASSETTE = 'pages'
POSTINGS_CASSETTE = 'postings'
DB_PAGES_CASSETTE = 'db_page'

if File.file?('config/app.yml')
  credentials = YAML.load(File.read('config/app.yml'))
  ENV['FB_CLIENT_ID'] = credentials['development']['FB_CLIENT_ID']
  ENV['FB_CLIENT_SECRET'] = credentials['development']['FB_CLIENT_SECRET']
  ENV['FB_ACCESS_TOKEN'] = credentials['development']['FB_ACCESS_TOKEN']
  ENV['FB_PAGE_ID'] = credentials['development']['FB_PAGE_ID']
end

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  c.filter_sensitive_data('<ACCESS_TOKEN>') do
    URI.unescape(app.config.FB_ACCESS_TOKEN)
  end

  c.filter_sensitive_data('<ACCESS_TOKEN_ESCAPED>') do
    app.config.FB_ACCESS_TOKEN
  end

  c.filter_sensitive_data('<CLIENT_ID>') { ENV['FB_CLIENT_ID'] }
  c.filter_sensitive_data('<CLIENT_SECRET>') { ENV['FB_CLIENT_SECRET'] }
end


PAGE_URL_2 = 'https://www.facebook.com/time'
HAPPY_PAGE_URL = 'https://www.facebook.com/cyberbuzz'
SAD_PAGE_URL = 'https://www.facebook.com/123smallthree'
BAD_PAGE_URL = 'htt://www.facebook'

SAD_PAGE_ID = '00000'
SAD_POSTING_ID = '13245_12324'
REMOVED_FB_POSTING_ID = '13245_12324'

