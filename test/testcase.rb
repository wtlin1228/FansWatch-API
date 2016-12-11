# frozen_string_literal: true
require_relative 'test_helper'

describe 'For test usage' do
  describe 'Generate testcase with facebook page url' do

    it 'HAPPY: should generate insider page data' do
      post 'api/v0.1/db_page/json',
      {"url": "https://www.facebook.com/cyberbuzz"}.to_json,
      'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200

      Page.count.must_be :>=, 1
      Posting.count.must_be :>=, 25
    end

    it 'HAPPY: should generate time page data' do
      post 'api/v0.1/db_page/json',
      {"url": "https://www.facebook.com/time"}.to_json,
      'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200

      Page.count.must_be :>=, 1
      Posting.count.must_be :>=, 25
    end

    it 'HAPPY: should generate time page data' do
      post 'api/v0.1/db_page/json',
      {"url": "https://www.facebook.com/cnn"}.to_json,
      'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200

      Page.count.must_be :>=, 1
      Posting.count.must_be :>=, 25
    end
  end

end

