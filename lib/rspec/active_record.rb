# frozen_string_literal: true

require "active_record"
require "rspec/expectations"
require "rspec/mocks"

module RSpec
  # Various helpers and matchers to help with specs when working with ActiveRecord models.
  # It is automatically included in RSpec specs.
  module ActiveRecord
    autoload :ChangeRecord, "rspec/active_record/change_record"
    autoload :CreateRecord, "rspec/active_record/create_record"
    autoload :DiffForMultipleRecords, "rspec/active_record/diff_for_multiple_records"
    autoload :StubModels, "rspec/active_record/stub_models"
    autoload :VERSION, "rspec/active_record/version"

    include StubModels

    # Allows matching that code inside a block created specific record.
    # @param scope [ActiveRecord::Relation, Class] Model class or a record where the record should be created.
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

    # Allows matching that code inside a block changed specific record.
    # @param record [ActiveRecord::Base] Model that we're checking for changes
    # @return [ChangeRecord]
    # @example Block updated user name to specific one
    #   expect { user.update!(name: "RSpec User") }.to change_record(user).to(name: "RSpec User")
    # @example Block updated user name from specific one
    #   expect { user.update!(name: "RSpec User") }.to change_record(user).from(name: "Initial Name")
    def change_record(record)
      ChangeRecord.new(record)
    end
  end
end
RSpec.configuration.include RSpec::ActiveRecord
