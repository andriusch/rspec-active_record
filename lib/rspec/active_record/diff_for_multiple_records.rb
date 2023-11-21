# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # @api private
    class DiffForMultipleRecords
      def initialize(attributes, records)
        @attributes = attributes
        @records = records
      end

      def call
        @records.map do |record|
          record_attributes = @attributes.keys.index_with { |key| record.__send__(key) }
          diff = RSpec::Expectations.differ.diff(record_attributes, @attributes)
          "Diff for #{record.class.name}##{record.__send__(record.class.primary_key)}\n#{diff}"
        end.join("\n\n")
      end
    end
  end
end
