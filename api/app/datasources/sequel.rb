# frozen_string_literal: true

require 'sequel'
require 'sqlite3'
require 'yaml'

module App
  module Datasource
    module Sequel
      class << self
        def config
          @config ||= begin
            file = File.join(PROJECT_ROOT, 'config', 'sequel.yml')
            YAML.load_file(file)[ENVIRONMENT]
          end
        end
      end

      DB ||= ::Sequel.connect(config)
    end
  end
end
