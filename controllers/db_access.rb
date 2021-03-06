# frozen_string_literal: true

# FansWatchAPI web service
class FansWatchAPI < Sinatra::Base
  
  # get first page from database
  get "/#{API_VER}/db_page/?" do
    begin
      page = Page.all.first

      content_type 'application/json'
      { id: page.id, fb_id: page.fb_id, name: page.name }.to_json
    rescue
      content_type 'text/plain'
      halt 404, "FB Page not found"
    end
  end

  post "/#{API_VER}/forTest/?" do
    begin
      Page.create(fb_id: "1234", name: "Leo")
      Posting.create(
        fb_id: "test_fb_id_1" ,
        page_id: "test_page_id_1",
        created_time: "test_created_time_1" ,
        message: "test_message_1" ,
        attachment_title: "test_attachment_title_1" ,
        attachment_description: "test_attachment_description_1" ,
        attachment_imgurl: "test_attachment_imgurl_1" ,
        attachment_url: "test_attachment_url_1"
      )      
      content_type 'text/plain'
      "generate test pattern"
    rescue
      content_type 'text/plain'
      halt 404, "Cannot generate test pattern"
    end
  end

  # Get all pages
  get "/#{API_VER}/allpages/?" do
    results = FindPages.call

    content_type 'application/json'
    PagesRepresenter.new(results.value).to_json
  end

  # Get page by id
  get "/#{API_VER}/onepage/:id/?" do
    result = FindPage.call(params)

    if result.success?
      PageRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
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
      db_page = Page.create(fb_id: page_id, name: page_name, fb_url: fb_page_url)

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
      { page_id: db_page.id, name: db_page.name, fb_url: db_page.fb_url}.to_json

    rescue
      content_type 'text/plain'
      halt 500, "Cannot create page (id: #{page_id})"
    end
  end

  # post request with json params
  post "/#{API_VER}/db_page/json/?" do
    result = LoadPageFromFB.call(request.body.read)

    if result.success?
      PageRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
