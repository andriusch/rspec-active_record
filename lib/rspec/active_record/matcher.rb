# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # A matcher
    class Matcher
      include RSpec::Matchers::Composable

      def supports_block_expectations?
        true
      end

      private

      def format_hash(hash)
        improve_hash_formatting RSpec::Support::ObjectFormatter.format(surface_descriptions_in(hash))
      end
    end
  end
end
