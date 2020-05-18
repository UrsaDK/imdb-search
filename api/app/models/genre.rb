# frozen_string_literal: true

require 'app/datasources/sequel'
require 'app/models/title_basics'

module App
  module Model
    class Genre < Sequel::Model
      many_to_many :title_basics
    end
  end
end
