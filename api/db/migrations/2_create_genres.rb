# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:genres) do
      primary_key :id
      String :name, null: false, unique: true, index: true
    end
  end
end
