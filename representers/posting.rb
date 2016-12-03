# frozen_string_literal: true

# Represents overall page information for JSON API output
class PostingRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :page_id, type: String
  property :created_time, type: Time
  property :message
  property :attachment_url
  property :attachment_title
  property :attachment_description
  property :attachment_imgurl
end
