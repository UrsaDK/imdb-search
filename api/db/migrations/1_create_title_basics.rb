# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:title_basics) do
      String :tconst, size: 16, null: false, primary_key: true
      String :titleType, null: false
      String :primaryTitle, null: true
      String :originalTitle, null: true
      Integer :startYear, null: false
      Integer :endYear, null: true
      Integer :runtimeMinutes, null: true
      TrueClass :isAdult, null: false
    end
  end
end
