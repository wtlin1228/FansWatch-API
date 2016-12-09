# frozen_string_literal: true

# Loads data from Facebook page to database
class FindPages
  extend Dry::Monads::Either::Mixin

  def self.call
    if (pages = Page.all).nil?
      Left(Error.new(:not_found, 'No pages found'))
    else
      Right(Pages.new(pages))
    end
  end
end
