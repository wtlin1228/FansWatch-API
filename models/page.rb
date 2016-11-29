# frozen_string_literal: true

# Represents a Page's stored information
class Page < Sequel::Model
  one_to_many :postings
end
