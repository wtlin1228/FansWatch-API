# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:pages) do
      primary_key :id
      String :fb_id
      String :name
    end
  end
end