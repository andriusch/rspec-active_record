# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # A matcher
    class CreateRecord < Matcher
      include RSpec::Matchers::BuiltIn::BaseMatcher::HashFormatting

      def initialize(scope)
        @scope = scope
        @attributes = []
        super()
      end

      # Make sure that created record matches attributes
      def matching(*attributes)
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

        match_times? && @attributes.all? { |attrs| match_attributes?(attrs) } && @new_records.present?
      end

      def description
        match_messages = @attributes.map do |attrs|
          " matching #{format_hash(attrs)}"
        end

        message = "create #{scope_name}"
        message += " #{@times} time#{"s" if @times != 1}" if @times
        message += match_messages.join(",")
        improve_hash_formatting message
      end

      def failure_message
        failure = "expected to #{description} but"
        if match_times?
          add_diff "#{failure} did not"
        else
          "#{failure} created #{@new_records.size}"
        end
      end

      def failure_message_when_negated
        "expected not to #{description} but did"
      end

      private

      def add_diff(message)
        @attributes.each do |attrs|
          message += "\n\n#{DiffForMultipleRecords.new(attrs, @new_records).call}" unless match_attributes?(attrs)
        end
        message
      end

      def match_times?
        @times.nil? || @times == @new_records.size
      end

      def match_attributes?(attrs)
        @new_records.any? { |record| RSpec::Matchers::BuiltIn::HaveAttributes.new(attrs).matches?(record) }
      end

      def scope_name
        @scope.try(:klass) || @scope
      end
    end
  end
end
