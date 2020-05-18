# frozen_string_literal: true

require File.expand_path('config/environment', __dir__)
require_dir(PROJECT_ROOT) { |path| %w[app].include?(path[0]) }
run Sinatra::Application
