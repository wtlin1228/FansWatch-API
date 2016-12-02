# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Page Routes' do

  before do
    VCR.insert_cassette DB_PAGES_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe '[DB]Find Page by its ID' do
    before do
      DB[:pages].delete
      DB[:postings].delete
      Page.create(fb_id: "1234", name: "Leo")
    end
    it 'HAPPY: should find a page given a correct id' do
      get "api/v0.1/db_page/1"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      page_data = JSON.parse(last_response.body)
      page_data['fb_id'].length.must_be :>, 0
      page_data['name'].length.must_be :>, 0
    end

    it 'SAD: should report if a page is not found' do
      get "api/v0.1/page/0"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_PAGE_ID
    end
  end

  describe 'Post a page\'s url and it should get the page\'s name and id' do
    before do
      DB[:pages].delete
      DB[:postings].delete
    end
    it 'HAPPY: should find the page' do
      post "api/v0.1/db_page/?url=#{HAPPY_PAGE_URL}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      body = JSON.parse(last_response.body)
      body.must_include 'name'
      body.must_include 'page_id'

      Page.count.must_equal 1
      Posting.count.must_be :>=, 10
    end

    it 'SAD: should report the page cannot be found' do
      post "api/v0.1/db_page/?url=#{SAD_PAGE_URL}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_PAGE_URL
    end

    it 'should report error if group already exists' do
      2.times do
        post "api/v0.1/db_page/?url=#{HAPPY_PAGE_URL}"
      end

      last_response.status.must_equal 422
    end
  end
end