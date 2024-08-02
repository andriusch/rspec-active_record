# Rspec::ActiveRecord

Implements helper methods & matchers when working with RSpec & ActiveRecord.

## Installation

Add it to Gemfile:

```ruby
group :test do
  gem "rspec-active_record", require: false
end
```

And require it in your `rails_helper` or `spec_helper` after `rspec/rails`:

```ruby
require "rspec/active_record"
```

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rspec-active_record

## Usage

### create_record

Check that block creates a record:

```ruby
expect { User.create!(name: "RSpec User") }.to create_record(User)
expect { User.create!(name: "RSpec User") }.to not_create_record(Company)
```

Sometimes you also need to match specific count of records:
```ruby
expect { User.create!(name: "RSpec User") }.to create_record(User).once
expect { User.create!(name: "RSpec User") }.to create_record(User).times(1)
```

You can also make sure that attributes match, if it fails you'll get RSpec diff between created record and what you expected:

```ruby
expect { User.create!(name: "RSpec User") }.to create_record(User).matching(name: "RSpec User")
```    

You can also achieve similar results using a scope, but not that in this case you won't see a diff:

```ruby
expect { User.create!(name: "RSpec User") }.to create_record(User.where(name: "RSpec User"))
```

### change_record

Check that code updates attributes of your record (note that it will automatically refind the record, so make sure changes are saved):
```ruby
expect { user.update!(name: "RSpec User") }.to change_record(user).to(name: "RSpec User")
```

Sometimes it's useful to specify what the attributes should've been initially:
```ruby
expect { user.update!(name: "RSpec User") }.to change_record(user).from(name: "Initial Name")
expect { user.name = "RSpec User" }.to not_change_record(user).from(name: "Initial Name")
```

### destroy_record

Check that code destroys a record:
```ruby
expect { user.destroy! }.to destroy_record(user)
expect { user.save! }.to not_destroy_record(user)
```

### stub_class

Stub class for a spec, pass a block to customize the class:

```ruby
stub_class :DummyDecorator, ApplicationDecorator do
  def object
    Object.new
  end
end
DummyDecorator.new.object #=> #<Object>
```

### stub_model

Similar to `stub_class` but automatically inherits from ApplicationRecord:


```ruby
stub_model :DummyUser do
  belongs_to :client, optional: true
end
DummyUser.new.client #=> nil
```

### create_temporary_table

Requires database that supports modifying structure inside transaction. Combines well with `stub_model` to create table for stubbed model:

```ruby
create_temporary_table :dummy_users do |t|
  t.belongs_to :client
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andriusch/rspec-active_record.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
