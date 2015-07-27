#!/usr/bin/env ruby
require_relative './boot'


class LogGouard < Sinatra::Base
  enable :inline_templates

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

    OmniAuth.config.full_host = CONFIG["full_host"]
  end

	get '/' do
    unless cookies[:authed] == "1"
      haml :need_to_login
    else
      haml :index
    end
  end

  get '/logout' do
    cookies[:authed]=nil
    # cookies.delete_cookie
    redirect to('/')
  end

  get '/auth/google_oauth2/callback' do
    if (request.env["omniauth.auth"]["info"]["email"] rescue "") =~ Regexp.new(CONFIG["domain_match"])
      cookies[:authed] = "1"
      redirect to('/?domain_match=true')
    else
      redirect to('/?domain_match=false')
    end
  end
end

__END__

@@ layout
%html
  %head
    %title Databox Logging
  %body
    .wrap
      %h1 Databox Logging
      = yield

@@ need_to_login
%div
  %p
    %a{href:"/auth/google_oauth2"} Login with Google Account

@@ index
%div
  %ul
    %li
      %a{href:"/kibana"} Kibana
      \-
      Central logging repository
    %li
      %a{href:"/kopf"} Kopf
      \-
      ElasticSearch cluster management
  %br/
  %br/
  %small
    %a{href:"/logout"} Logout
