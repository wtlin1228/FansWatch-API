# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

# require './init.rb'

include Rack::Test::Methods

def app
  FansWatchAPI
end

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
PAGES_CASSETTE = 'pages'
POSTINGS_CASSETTE = 'postings'

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

HAPPY_GROUP_URL = 'https://www.facebook.com/cyberbuzz'
SAD_GROUP_URL = 'https://www.facebook.com/123smallthree'
BAD_GROUP_URL = 'htt://www.facebook'

SAD_PAGE_ID = '00000'
SAD_POSTING_ID = '13245_12324'
REMOVED_FB_POSTING_ID = '13245_12324'

