# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # A matcher
    class ChangeRecord
      include RSpec::Matchers::Composable
      include RSpec::Matchers::BuiltIn::BaseMatcher::HashFormatting

      delegate :fail_with, to: RSpec::Expectations

      def initialize(record)
        @record = record
      end

      # Attributes of record should match these after block is executed
      def to(**attributes)
        @to = attributes
        self
      end

      # Attributes of record should match these before block is executed
      def from(**attributes)
        @from = attributes
        self
      end

      def supports_block_expectations?
        true
      end

      def matches?(block)
        @from_diff = diff_unless_match(@record, @from)
        @to_pre_match = !does_not_match_attributes?(@record, @to)

        block.call
        @updated_record = @record.class.find(@record.id)

        @to_diff = diff_unless_match(@updated_record, @to)
        @from_post_match = !does_not_match_attributes?(@updated_record, @from)

        (@from || @to) && !@from_diff && !@to_pre_match && !@to_diff && !@from_post_match
      end

      def does_not_match?(block)
        return false if @to || @from.blank?

        @from_diff = diff_unless_match(@record, @from)
        return false if @from_diff

        block.call
        @updated_record = @record.class.find(@record.id)

        @from_post_match = !does_not_match_attributes?(@updated_record, @from)
      end

      def description
        message = "change #{format_name(@record)}"
        message += " from #{format_hash(@from)}" if @from
        message += " to #{format_hash(@to)}" if @to
        message
      end

      def failure_message
        if @from_post_match
          "expected to change #{format_name(@record)} from #{format_hash(@from)} but did not"
        elsif @to_pre_match
          "expected #{format_name(@record)} to not match #{format_hash(@to)} initially but it did"
        elsif @from_diff
          "expected #{format_name(@record)} to match #{format_hash(@from)} initially but it did not#{@from_diff}"
        elsif @to_diff
          "expected to change #{format_name(@record)} to #{format_hash(@to)} but did not#{@to_diff}"
        else
          "please specify from or to for change_record"
        end
      end

      def failure_message_when_negated
        if @to
          "negative matcher for change_record with to is not supported"
        elsif @from.blank?
          "negative matcher for change_record without from is not supported"
        elsif @from_diff
          "expected #{format_name(@record)} to match #{format_hash(@from)} initially but it did not#{@from_diff}"
        elsif !@from_post_match
          "expected not to change #{format_name(@record)} from #{format_hash(@from)} but it did"
        end
      end

      private

      def format_name(record)
        "#{record.class.name}##{record.id}"
      end

      def format_hash(hash)
        improve_hash_formatting RSpec::Support::ObjectFormatter.format(surface_descriptions_in(hash))
      end

      def diff_unless_match(record, attributes)
        diff(record, attributes) unless match_attributes?(record, attributes)
      end

      def diff(record, attributes)
        "\n\n#{DiffForMultipleRecords.new(attributes, [record]).call}"
      end

      def match_attributes?(record, attributes)
        return true unless attributes

        RSpec::Matchers::BuiltIn::HaveAttributes.new(attributes).matches?(record)
      end

      def does_not_match_attributes?(record, attributes)
        return true unless attributes

        RSpec::Matchers::BuiltIn::HaveAttributes.new(attributes).does_not_match?(record)
      end
    end
  end
end
