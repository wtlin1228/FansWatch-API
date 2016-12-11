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

  if File.file?('config/app.yml')
    credentials = YAML.load(File.read('config/app.yml'))
    ENV['FB_CLIENT_ID'] = credentials['development']['FB_CLIENT_ID']
    ENV['FB_CLIENT_SECRET'] = credentials['development']['FB_CLIENT_SECRET']
    ENV['FB_ACCESS_TOKEN'] = credentials['development']['FB_ACCESS_TOKEN']
    ENV['FB_PAGE_ID'] = credentials['development']['FB_PAGE_ID']
  end

  get '/?' do
    "FansWatchAPI latest version endpoints are at: /#{API_VER}/"
  end
end
