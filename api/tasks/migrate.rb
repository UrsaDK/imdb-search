# frozen_string_literal: true

require 'sequel/core'

module Task
  module Migrate
    Sequel.extension :migration

    class << self
      def all
        Sequel.connect(config) do |db|
          Sequel::Migrator.run(db, migrations_dir)
        end
      end

      def to(migration_number)
        Sequel.connect(config) do |db|
          Sequel::Migrator.run(db, migrations_dir, target: migration_number)
        end
      end

      private

      def config
        @config ||= begin
          file = File.join(PROJECT_ROOT, 'config', 'sequel.yml')
          YAML.load_file(file)[ENVIRONMENT]
        end
      end

      def migrations_dir
        @migrations_dir ||= File.join(PROJECT_ROOT, 'db', 'migrations')
      end
    end
  end
end
