# frozen_string_literal: true

module RSpec
  module ActiveRecord
    # Used for stubbing classes in your tests
    module StubModels
      # Stub a class with specific name for testing.
      # @param name [#to_s] Name of stubbed class.
      # @param parent [Class] Parent class of stubbed class.
      # @yield Pass the block to further customize the class.
      # @example
      #   stub_class :DummyDecorator, ApplicationDecorator do
      #     def object = Object.new
      #   end
      #   DummyDecorator.new.object #=> #<Object>
      def stub_class(name, parent = Object, &block)
        stub_const(name.to_s, Class.new(parent, &block))
      end

      # Stub a model with specific name for testing.
      # @param name [#to_s] Name of stubbed class.
      # @param parent [Class] Parent class of stubbed class.
      # @yield Pass the block to further customize the class.
      # @see #create_temporary_table
      # @example
      #   stub_model :DummyUser do
      #     belongs_to :client, optional: true
      #   end
      #   create_temporary_table :dummy_users do |t|
      #     t.belongs_to :client
      #   end
      #   DummyUser.new.client #=> nil
      def stub_model(name, parent = ApplicationRecord, &block)
        stub_class(name, parent) do
          self.table_name = name.to_s.tableize
          class_eval(&block) if block
        end
      end

      # Creates temporary table. Only works correctly if DDL transactions are enabled.
      # Takes same arguments as `create_table` in ActiveRecord migration.
      def create_temporary_table(*args, **options, &block)
        ::ActiveRecord::Base.connection.create_table(*args, **options, &block)
      end
    end
  end
end
