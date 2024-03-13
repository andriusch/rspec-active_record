# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # A matcher
    class RecordMatcher
      include RSpec::Matchers::Composable

      def initialize(record)
        @record = record
      end

      def supports_block_expectations?
        true
      end

      private

      def format_record
        "#{@record.class.name}##{@record.id}"
      end
    end
  end
end
