# frozen_string_literal: true

require "active_record"
require "rspec/expectations"
require "rspec/mocks"

module RSpec
  # Various helpers and matchers to help with specs when working with ActiveRecord models.
  # It is automatically included in RSpec specs.
  module ActiveRecord
    autoload :CreateRecord, "rspec/active_record/create_record"
    autoload :DiffForMultipleRecords, "rspec/active_record/diff_for_multiple_records"
    autoload :StubModels, "rspec/active_record/stub_models"
    autoload :VERSION, "rspec/active_record/version"

    include StubModels

    # Allows matching that code inside a block created specific record.
    # @param scope [ActiveRecord::Relation, Class] Model class or a scope where the record should be created.
    # @return [CreateRecord]
    # @example Block created any User
    #   expect { User.create!(name: "RSpec User") }.to create_record(User)
    # @example Block create a User matching specific name
    #   expect { User.create!(name: "RSpec User") }.to create_record(User).matching(name: "RSpec User")
    # @example Block create a User matching specific name
    #   expect { User.create!(name: "RSpec User") }.to create_record(User.where(name: "RSpec User"))
    def create_record(scope)
      CreateRecord.new(scope)
    end
  end
end
RSpec.configuration.include RSpec::ActiveRecord
