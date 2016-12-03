# frozen_string_literal: true
require_relative 'page'

# Represents overall page information for JSON API output
class PagesRepresenter < Roar::Decorator
  include Roar::JSON

  collection :pages, extend: GroupRepresenter, class: Group
end
