# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Page Routes' do

  before do
    VCR.insert_cassette PAGES_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find Page by its Facebook ID' do
    it 'HAPPY: should find a page given a correct id' do
      get "api/v0.1/page/#{app.config.FB_PAGE_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      page_data = JSON.parse(last_response.body)
      page_data['page_id'].length.must_be :>, 0
      page_data['name'].length.must_be :>, 0
    end

    it 'SAD: should report if a page is not found' do
      get "api/v0.1/page/#{SAD_PAGE_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_PAGE_ID
    end
  end

  describe 'Get the latest feed from a page' do
    it 'HAPPY should find a page feed' do
      get "api/v0.1/page/#{app.config.FB_PAGE_ID}/feed"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      feed_data = JSON.parse(last_response.body)
      feed_data['feed'].count.must_be :>=, 25
    end

    it 'SAD should report if the feed cannot be found' do
      get "api/v0.1/page/#{SAD_PAGE_ID}/feed"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_PAGE_ID
    end
  end
end
