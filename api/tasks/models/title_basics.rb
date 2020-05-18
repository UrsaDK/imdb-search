# frozen_string_literal: true

module Task
  module Model
    module TitleBasics
      class << self
        # @yeild [formatted_line] Executes block for each line of the file.
        # @yieldparam data [Hash] A hash of the line, with column headers as keys,
        #                         and values as they are returned by Formatter.
        def each_line(file)
          content = Task::Datasource::Tsv.new(file)
          content.formatter = TitleBasics::Formatter
          content.each_line do |data|
            yield(data) if block_given?
          end
        end

        def total_records(file)
          count = -1 # The first line is the header, not a record
          content = Task::Datasource::Tsv.new(file)
          content.source.each_line { count += 1 }
          count.negative? ? 0 : count
        end
      end

      module Formatter
        class << self
          def sanitize(value)
            value = value.to_s.strip
            return nil if value == '\N'
            value
          end

          def normalize(value)
            return nil unless (value = sanitize(value))
            value.downcase
          end

          def to_integer(value)
            return nil unless (value = sanitize(value))
            value.to_i
          end

          def to_boolean(value)
            return nil unless (value = to_integer(value))
            !value.zero?
          end

          def to_normalized_array(value)
            return nil unless (value = sanitize(value))
            value.split(',').map { |v| v.strip.downcase.capitalize }
          end

          alias titleType normalize
          alias primaryTitle sanitize
          alias originalTitle sanitize
          alias startYear to_integer
          alias endYear to_integer
          alias runtimeMinutes to_integer
          alias isAdult to_boolean
          alias genres to_normalized_array
        end
      end
    end
  end
end
