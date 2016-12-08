# frozen_string_literal: true

# Loads data from Facebook page to database
class FindPage
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    if (page = Page.find(id: params[:id])).nil?
      Left(Error.new(:not_found, 'FB Page not found'))
    else
      Right(page)
    end
  end
end
