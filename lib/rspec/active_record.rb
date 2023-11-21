# frozen_string_literal: true

require "active_record"
require "rspec/expectations"
require "rspec/mocks"


module RSpec
  # Automatically included in RSpec specs
  module ActiveRecord
    autoload :CreateRecord, "rspec/active_record/create_record"
    autoload :DiffForMultipleRecords, "rspec/active_record/diff_for_multiple_records"
    autoload :StubModels, "rspec/active_record/stub_models"
    autoload :VERSION, "rspec/active_record/version"

    include StubModels

    def create_record(scope)
      CreateRecord.new(scope)
    end
  end
end
RSpec.configuration.include RSpec::ActiveRecord
