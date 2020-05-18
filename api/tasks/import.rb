# frozen_string_literal: true

require 'ruby-progressbar'

module Task
  module Import
    class << self
      def title_basics(file)
        require 'app/models/title_basics'
        total_records = Task::Model::TitleBasics.total_records(file)
        progressbar = init_progressbar(total_records)
        Task::Model::TitleBasics.each_line(file) do |data|
          App::Model::TitleBasics.add_row(data)
          progressbar.increment
        end
      end

      private

      def init_progressbar(total)
        format = '%a |%b %p%% %i| %e   Processed %c  of %C records'
        ProgressBar.create(total: total, format: format)
      end
    end
  end
end
