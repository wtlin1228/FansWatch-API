# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:postings) do
      primary_key :id
      foreign_key :page_id

      String :fb_id
      String :created_time
      String :message
      String :attachment_title
      String :attachment_description
      String :attachment_imgurl
      String :attachment_url
    end
  end
end
