# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # A matcher
    class DestroyRecord < RecordMatcher
      def matches?(block)
        block.call
        !@record.class.exists?(@record.id)
      end

      def description
        "destroy #{format_record}"
      end

      def failure_message
        "expected to #{description} but did not"
      end

      def failure_message_when_negated
        "expected not to #{description} but did"
      end
    end
  end
end
