# frozen_string_literal: true

# FansWatchAPI web service
class FansWatchAPI < Sinatra::Base

  get "/#{API_VER}/db_page/:id/?" do
    page_id = params[:id]
    begin
      page = Page.find(id: page_id)

      content_type 'application/json'
      { id: page.id, fb_id: page.fb_id, name: page.name }.to_json
    rescue
      content_type 'text/plain'
      halt 404, "FB Page (id: #{page_id}) not found"
    end
  end

  # Body args (JSON) e.g.: {"url": "http://facebook.com/groups/group_name"}
  post "/#{API_VER}/db_page/?" do
    begin
      body_params = request.params
      fb_page_url = body_params['url'].to_s
      fb_page_id  = FansWatch::FbApi.page_id(fb_page_url)
      
      fb_page = FansWatch::Page.find(id: fb_page_id)
      
      page_id = fb_page.id
      page_name = fb_page.name
      if Page.find(fb_id: page_id)
        halt 422, "Page (id: #{page_id}) already exists"
      end
      
    rescue
      content_type 'text/plain'
      halt 404, "Cannot find page by url (url: #{fb_page_url} )"
    end

    begin
      db_page = Page.create(fb_id: page_id, page_name: page_name)

      fb_page.feed.postings.each do |fb_posting|
        Posting.create(
          page_id:       db_page.id,
          fb_id:         fb_posting.id,
          created_time:  fb_posting.created_time,
          message:       fb_posting.message,
          attachment_title:        fb_posting.attachment&.title,
          attachment_description:  fb_posting.attachment&.description,
          attachment_url:          fb_posting.attachment&.url,
          attachment_imgurl:       fb_posting.attachment&.image_url
        )
      end

      content_type 'application/json'
      { page_id: db_page.id, name: db_page.name }.to_json

    rescue
      content_type 'text/plain'
      halt 500, "Cannot create page (id: #{page_id})"
    end
  end
end
