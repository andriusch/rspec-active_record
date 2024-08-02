# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # A matcher
    class RecordMatcher < Matcher
      def initialize(record)
        super()
        @record = record
      end

      private

      def format_record
        "#{@record.class.name}##{@record.id}"
      end
    end
  end
end
