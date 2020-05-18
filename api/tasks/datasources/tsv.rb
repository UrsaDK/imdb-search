# frozen_string_literal: true

require 'zlib'

module Task
  module Datasource
    class Tsv
      attr_reader :headers
      attr_accessor :formatter, :source

      def initialize(file)
        @source = File.open(file)
        @source = Zlib::GzipReader.new(source) if File.extname(file) == '.gz'
      rescue StandardError
        raise ArgumentError, "Missing or invalid file -- #{file}"
      end

      # @yield [data] Executes block for each line of the source.
      # @yieldparam data [Hash] A hash of the line, with column headers as keys,
      #                         and values as they are returned by @formatter.
      def each_line
        source.each_line do |line|
          if source.lineno == 1
            @headers = split_line(line)
          else
            values = split_line(line)
            data = format_data(Hash[headers.zip(values)])
            yield(data) if block_given?
          end
        end
      end

      private

      def split_line(line)
        line.strip.split("\t").map(&:strip)
      end

      def format_data(data)
        return data if formatter.nil?
        data.map do |header, value|
          method = header.to_sym
          begin
            value = formatter.send(method, value) if formatter.methods.include?(method)
          rescue StandardError
            raise StandardError, "Invalid formatter method -- #{formatter}.#{header}"
          end
          [header, value]
        end.to_h
      end
    end
  end
end
