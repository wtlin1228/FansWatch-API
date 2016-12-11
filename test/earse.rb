# frozen_string_literal: true
require_relative 'test_helper'

describe 'Delete all database' do
  describe 'Clear the page and posting table' do
  	before do
      DB[:pages].delete
      DB[:postings].delete
    end

    it 'HAPPY: database should be empty' do
      Page.count.must_equal 0
      Posting.count.must_equal 0
    end
  end

end



    