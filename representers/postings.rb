# frozen_string_literal: true
require_relative 'posting'

# Represents overall page information for JSON API output
class PostingsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :postings, extend: PostingRepresenter, class: Posting
end
