# frozen_string_literal: true

module RSpec
  module ActiveRecord
    module StubModels
      def stub_class(name, parent = Object, &block)
        stub_const(name.to_s, Class.new(parent, &block))
      end

      def stub_model(name, parent = ApplicationRecord, &block)
        stub_class(name, parent) do
          self.table_name = name.to_s.tableize
          class_eval(&block) if block
        end
      end

      def create_temporary_table(*args, **options, &block)
        ::ActiveRecord::Base.connection.create_table(*args, **options, &block)
      end
    end

  end
end

