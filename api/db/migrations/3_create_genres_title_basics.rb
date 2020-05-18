# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:genres_title_basics) do
      foreign_key :title_basics_id, :title_basics, key: :tconst, null: false
      foreign_key :genre_id, :genres, key: :id, null: false
      primary_key %i[title_basics_id genre_id]
      index %i[title_basics_id genre_id]
    end
  end
end
