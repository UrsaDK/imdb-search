# frozen_string_literal: true

require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cors'
require 'sinatra/json'
require 'sinatra/namespace'

config_file(File.join(PROJECT_ROOT, 'config', 'sinatra.yml'))

if development?
  require 'sinatra/reloader'
  Dir.glob(File.join(PROJECT_ROOT, 'app', '**', '*.rb')) do |file|
    also_reload file unless file == __FILE__
  end
end

# Avoid serving duplicate content at multiple locations
before '/*/' do
  redirect request.path_info.chomp('/')
end

get '/' do
  json(
    title: 'Movie Search API Status',
    description: 'A list of all available versions of the API.',
    available_versions: {
      v1: "#{request.path_info.chomp('/')}/v1"
    },
    default_version: 'v1',
    deprecated_versions: [],
    environment: ENVIRONMENT
  )
end
