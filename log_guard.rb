#!/usr/bin/env ruby
require_relative './boot'

OmniAuth.config.full_host = CONFIG["full_host"]

class LogGouard < Sinatra::Base
  helpers Sinatra::Cookies

  use Rack::Session::Cookie

  use OmniAuth::Builder do
    provider :google_oauth2,
             CONFIG['auth']['google_oauth2']['client_id'],
             CONFIG['auth']['google_oauth2']['secret_id'], {
                 scope: 'email',
                 # site: "https://www.googleapis.com",
                 # token_url: "/oauth2/v3/token"
                 # provider_ignores_state: true,
                 # name: 'Databox Logging'
             }
  end

	get '/' do
    '<a href="/auth/google_oauth2">Login w/ Google Account</a>'
  end

  get '/test' do
    {ime: "Oto"}.to_json
  end

  get '/auth/google_oauth2/callback' do
    request.env["omniauth.auth"].to_json
  end
end
