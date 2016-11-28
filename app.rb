# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'fanswatch'

# GroupAPI web service
class FansWatchAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root
  FansWatch::FbApi
    .config
    .update(client_id: config.FB_CLIENT_ID,
            client_secret: config.FB_CLIENT_SECRET)

  API_VER = 'api/v0.1'

  get '/?' do
    "FansWatchAPI latest version endpoints are at: /#{API_VER}/"
  end

  get "/#{API_VER}/page/:fb_page_id/?" do
    page_id = params[:fb_page_id]
    begin
      page = FansWatch::Page.find(id: page_id)

      content_type 'application/json'
      { page_id: page.id, name: page.name }.to_json
    rescue
      halt 404, "FB Page (id: #{page_id}) not found"
    end
  end

  get "/#{API_VER}/page/:fb_page_id/feed/?" do
    page_id = params[:fb_page_id]
    begin
      page = FansWatch::Page.find(id: page_id)

      content_type 'application/json'
      {
        feed: page.feed.postings.map do |post|
          posting = { posting_id: post.id }
          posting[:message] = post.message if post.message
          if post.attachment
            posting[:attachment] = {
              title: post.attachment.title,
              url: post.attachment.url,
              description: post.attachment.description,
              image_url: post.attachment.image_url
            }
          end

          { posting: posting }
        end
      }.to_json
    rescue
      halt 404, "Cannot page (id: #{page_id}) feed"
    end
  end
end