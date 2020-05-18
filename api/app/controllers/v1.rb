# frozen_string_literal: true

require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cors'
require 'sinatra/json'
require 'sinatra/namespace'

namespace '/v1' do
  get do
    json(
      title: 'Movie Search API - V1',
      description: 'A list of all available endpoints.',
      version: File.read(File.join(PROJECT_ROOT, 'VERSION')).chomp,
      available_endpoints: {
        primaryTitle: "#{request.path_info.chomp('/')}/primaryTitle",
        originalTitle: "#{request.path_info.chomp('/')}/originalTitle"
      }
    )
  end

  get %r{\/(original|primary)Title} do
    column = File.basename(request.path_info)
    path = request.path_info.chomp('/')
    json(
      title: column,
      description: "Search for a string that appears in the #{column} column.",
      format: "#{path}/:search_string"
    )
  end

  get %r{\/(originalTitle|primaryTitle)/(.*)} do |column, query|
    json(
      App::Model::TitleBasics.find_by_column(column, query)
    )
  end
end
