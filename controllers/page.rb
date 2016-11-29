# frozen_string_literal: true

# FansWatchAPI web service
class FansWatchAPI < Sinatra::Base
  
  get "/#{API_VER}/page/:fb_page_id/?" do
    page_id = params[:fb_page_id]
    begin
      page = FansWatch::Page.find(id: page_id)

      content_type 'application/json'
      { page_id: page.id, name: page.name }.to_json
    rescue
      content_type 'text/plain'
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
      content_type 'text/plain'
      halt 404, "Cannot page (id: #{page_id}) feed"
    end
  end

  # Body args (JSON) e.g.: {"url": "http://facebook.com/page/page_name"}
  post "/#{API_VER}/page/?" do
    begin
      body_params = request.params
      fb_page_url = body_params['url'].to_s
      fb_page_id  = FansWatch::FbApi.page_id(fb_page_url)
      
      page = FansWatch::Page.find(id: fb_page_id)

      content_type 'application/json'
      { page_id: page.id, name: page.name }.to_json
    rescue
      content_type 'text/plain'
      halt 404, "Cannot find page by url (url: #{fb_page_url} )"
    end
  end
end
