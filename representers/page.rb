# frozen_string_literal: true

# Represents overall page information for JSON API output
class PageRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  property :fb_url
end
