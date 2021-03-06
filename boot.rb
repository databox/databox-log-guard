require 'bundler/setup'
require 'sinatra'
require 'sinatra/cookies'

require 'omniauth'
require 'omniauth-google-oauth2'

require 'yaml'
require 'erb'
require 'haml'

ENV['LOG_GUARD_ENV'] ||= ENV['LOG_GUARD_ENV'] || ENV['RACK_ENV'] || 'development'

CONFIG = YAML.load(ERB.new(IO.read("./config/config.yml")).result)[ENV['LOG_GUARD_ENV']]
