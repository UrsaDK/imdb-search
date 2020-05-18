# frozen_string_literal: true

require 'app/datasources/sequel'
require 'app/models/genre'

module App
  module Model
    class TitleBasics < Sequel::Model
      unrestrict_primary_key
      many_to_many :genres

      class << self
        def add_row(data)
          genres = data.delete('genres')
          tb = create(data)
          return if genres.nil?
          genres.each do |genre|
            g = App::Model::Genre.find_or_create(name: genre)
            tb.add_genre(g)
          end
        end

        def find_by_column(column, query)
          condition = Sequel.ilike(column.to_sym, "%#{query}%")
          where(condition).map(&:to_api)
        end
      end

      def to_api
        to_hash.merge(genres: genres.map(&:name))
      end
    end
  end
end
