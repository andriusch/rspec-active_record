# frozen_string_literal: true

require_relative "lib/rspec/active_record/version"

Gem::Specification.new do |spec|
  spec.name = "rspec-active_record"
  spec.version = RSpec::ActiveRecord::VERSION
  spec.authors = ["Andrius Chamentauskas"]
  spec.email = ["andrius.chamentauskas@gmail.com"]

  spec.summary = "RSpec matchers for ActiveRecord"
  spec.description = "RSpec matchers to check when ActiveRecord objects are created/updated/destroyed"
  spec.homepage = "https://github.com/andriusch/rspec-active_record"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "rspec-expectations"
  spec.add_dependency "rspec-mocks"

  spec.add_development_dependency "database_cleaner-active_record"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "sqlite3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
