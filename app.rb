# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'fanswatch'

ENV['RACK_ENV'] ||= 'development'
Econfig.env = ENV['RACK_ENV']
Econfig.root = File.dirname(__FILE__)

# FansWatch_API service space
module FansWatchAPI
  extend Econfig::Shortcut

  # FansWatch_API web service
  class API < Sinatra::Base
    API_VER = 'v0.1'

    get '/?' do
      "FansWatchAPI latest version endpoints are at: /#{API_VER}/"
    end

    get "/#{API_VER}/page/:fb_page_id/?" do
      page = FansWatch::Page.find(
        id: params[:fb_page_id]
      )

      { page_id: page.id, name: page.name }.to_json
    end

    get "/#{API_VER}/page/:fb_page_id/feed/?" do
      page = FansWatch::Page.find(
        id: params[:fb_page_id]
      )

      {
        feed: page.feed.postings.map do |post|
          {
            posting: {
              posting_id: post.id
            }
          }
        end
      }.to_json
    end
  end
end