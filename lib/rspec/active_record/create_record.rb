# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # A matcher
    class CreateRecord < Matcher
      include RSpec::Matchers::BuiltIn::BaseMatcher::HashFormatting

      def initialize(scope)
        @scope = scope
        super()
      end

      # Make sure that created record matches attributes
      def matching(attributes)
        @attributes = attributes
        self
      end

      def times(times)
        @times = times
        self
      end

      def once
        times(1)
      end

      def twice
        times(2)
      end

      def thrice
        times(3)
      end

      def supports_block_expectations?
        true
      end

      def matches?(block)
        existing_ids = @scope.ids
        block.call

        @new_records = @scope.where.not(@scope.primary_key => existing_ids).to_a

        match_times? && match_attributes? && @new_records.present?
      end

      def description
        message = "create #{scope_name}"
        message += " #{@times} time#{"s" if @times != 1}" if @times
        message += " matching #{format_hash(@attributes)}" if @attributes
        improve_hash_formatting message
      end

      def failure_message
        failure = "expected to #{description} but"
        if !match_times?
          "#{failure} created #{@new_records.size}"
        else
          add_diff "#{failure} did not"
        end
      end

      def failure_message_when_negated
        "expected not to #{description} but did"
      end

      private

      def add_diff(message)
        message += "\n\n#{DiffForMultipleRecords.new(@attributes, @new_records).call}" if @attributes
        message
      end

      def match_times?
        @times.nil? || @times == @new_records.size
      end

      def match_attributes?
        @attributes.nil? ||
          @new_records.any? { |record| RSpec::Matchers::BuiltIn::HaveAttributes.new(@attributes).matches?(record) }
      end

      def scope_name
        @scope.try(:klass) || @scope
      end
    end
  end
end
