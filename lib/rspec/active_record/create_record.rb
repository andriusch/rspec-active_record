module RSpec
  module ActiveRecord
    class CreateRecord
      include RSpec::Matchers::Composable
      include RSpec::Matchers::BuiltIn::BaseMatcher::HashFormatting

      def initialize(scope)
        @scope = scope
      end

      # Make sure that created record matches attributes
      def matching(**attributes)
        @attributes = attributes
        self
      end

      def supports_block_expectations?
        true
      end

      def matches?(block)
        existing_ids = @scope.ids
        block.call

        @new_records = @scope.where.not(@scope.primary_key => existing_ids)

        if @attributes
          match_attributes?
        else
          @new_records.present?
        end
      end

      def description
        message = "create #{scope_name}"
        if @attributes
          message += " matching #{RSpec::Support::ObjectFormatter.format(surface_descriptions_in(@attributes))}"
        end
        improve_hash_formatting message
      end

      def failure_message
        add_diff "expected to #{description} but did not"
      end

      def failure_message_when_negated
        "expected not to #{description} but did"
      end

      private

      def add_diff(message)
        message += "\n\n#{DiffForMultipleRecords.new(@attributes, @new_records).call}" if @attributes
        message
      end

      def match_attributes?
        @new_records.any? { |record| RSpec::Matchers::BuiltIn::HaveAttributes.new(@attributes).matches?(record) }
      end

      def scope_name
        @scope.try(:klass) || @scope
      end
    end
  end
end
