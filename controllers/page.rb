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

  # Body args (JSON) e.g.: {"url": "http://facebook.com/page/page_name"}
  post "/#{API_VER}/page/?" do
    begin
      body_params = request.params
      fb_page_url = body_params['url'].to_s
      fb_page_id  = FansWatch::FbApi.page_id(fb_page_url)

      if Page.find(fb_id: fb_page_id)
        halt 422, "Page (id: #{fb_page_id})already exists"
      end

      fb_page = FansWatch::Page.find(id: fb_page_id)
    rescue
      content_type 'text/plain'
      halt 400, "page (url: #{fb_page_url}) could not be found"
    end

    begin
      page = Page.create(fb_id: fb_page.id, name: fb_page.name)

      fb_page.feed.postings.each do |fb_posting|
        Posting.create(
          page_id:        page.id,
          fb_id:          fb_posting.id,
          created_time:   fb_posting.created_time,
          updated_time:   fb_posting.updated_time,
          message:        fb_posting.message,
          name:           fb_posting.name,
          attachment_title:         fb_posting.attachment&.title,
          attachment_description:   fb_posting.attachment&.description,
          attachment_url:           fb_posting.attachment&.url,
          attachment_imgurl:        fb_posting.attachment&.image_url
        )
      end

      content_type 'application/json'
      { page_id: page.id, name: page.name }.to_json
    rescue
      content_type 'text/plain'
      halt 500, "Cannot create page (id: #{fb_page_id})"
    end
  end
end