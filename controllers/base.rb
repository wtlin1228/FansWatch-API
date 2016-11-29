# frozen_string_literal: true

# configure based on environment
class FansWatchAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = File.expand_path('..', settings.root)
  FansWatch::FbApi
    .config
    .update(client_id: config.FB_CLIENT_ID,
            client_secret: config.FB_CLIENT_SECRET)

  API_VER = 'api/v0.1'

  get '/?' do
    "FansWatchAPI latest version endpoints are at: /#{API_VER}/"
  end
end
