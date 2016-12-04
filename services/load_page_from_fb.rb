# frozen_string_literal: true

# Loads data from Facebook page to database
class LoadPageFromFB
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_request_json, lambda { |request_body|
    begin
      url_representation = UrlRequestRepresenter.new(UrlRequest.new)
      Right(url_representation.from_json(request_body))
    rescue
      Left(Error.new(:bad_request, 'URL could not be resolved'))
    end
  }

  register :validate_request_url, lambda { |body_params|
    if (fb_page_url = body_params['url']).nil?
      Left(:cannot_process, 'URL not supplied')
    else
      Right(fb_page_url)
    end
  }

  register :parse_fb_page_id, lambda { |fb_page_url|
    begin
      page_info = { url: fb_page_url,
                  fb_id: FansWatch::FbApi.page_id(fb_page_url) }
      Right(page_info)
    rescue
      Left(Error.new(:bad_request, 'URL not recognized as Facebook page'))
    end
  }

  register :retrieve_page_and_postings_data, lambda { |page_info|
    if Page.find(fb_id: page_info[:fb_id])
      Left(Error.new(:cannot_process, 'Page already exists'))
    else
      page_info[:api_data] = FansWatch::Page.find(id: page_info[:fb_id])
      Right(page_info)
    end
  }

  register :create_page_and_postings, lambda { |page_info|
    page = Page.create(fb_id: page_info[:api_data].id,
                         name: page_info[:api_data].name,
                         fb_url: page_info[:url])
    page_info[:api_data].feed.postings.each do |fb_posting|
      write_page_posting(page, fb_posting)
    end
    Right(page)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :validate_request_url
      step :parse_fb_page_id
      step :retrieve_page_and_postings_data
      step :create_page_and_postings
    end.call(params)
  end

  private_class_method

  def self.write_page_posting(page, fb_posting)
    page.add_posting(
      fb_id:         fb_posting.id,
      created_time:  fb_posting.created_time,
      message:       fb_posting.message,
      attachment_title:        fb_posting.attachment&.title,
      attachment_description:  fb_posting.attachment&.description,
      attachment_url:          fb_posting.attachment&.url,
      attachment_imgurl:       fb_posting.attachment&.image_url
    )
  end
end
