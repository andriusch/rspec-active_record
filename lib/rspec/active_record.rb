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
    autoload :DestroyRecord, "rspec/active_record/destroy_record"
    autoload :DiffForMultipleRecords, "rspec/active_record/diff_for_multiple_records"
    autoload :Matcher, "rspec/active_record/matcher"
    autoload :RecordMatcher, "rspec/active_record/record_matcher"
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

    # Allows matching that code inside a block destroyed specific record.
    # @param record [ActiveRecord::Base] Model that should be destroyed
    # @return [ChangeRecord]
    # @example Block destroyed record
    #   expect { user.destroy! }.to destroy_record(user)
    def destroy_record(record)
      DestroyRecord.new(record)
    end
  end
end
RSpec.configuration.include RSpec::ActiveRecord

RSpec::Matchers.define_negated_matcher :not_create_record, :create_record
RSpec::Matchers.define_negated_matcher :not_change_record, :change_record
RSpec::Matchers.define_negated_matcher :not_destroy_record, :destroy_record
