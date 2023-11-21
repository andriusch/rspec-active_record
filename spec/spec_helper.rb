# frozen_string_literal: true

require "rspec/active_record"
require "rspec/matchers/fail_matchers"
require "database_cleaner/active_record"

require_relative "support/active_record_setup"
DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.max_formatted_output_length = nil
  end

  config.include RSpec::Matchers::FailMatchers

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
