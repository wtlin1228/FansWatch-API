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
      
      page = FansWatch::Page.find(id: fb_page_id)
      
      page_id = page.id
      page_name = page.name
      if !(Page.find(fb_id: page_id) )
        Page.insert(fb_id: page_id, page_name: page_name)

      content_type 'application/json'
      { page_id: page.id, name: page.name }.to_json
    rescue
      content_type 'text/plain'
      halt 404, "Cannot find page by url (url: #{fb_page_url} )"
    end
  end
end
