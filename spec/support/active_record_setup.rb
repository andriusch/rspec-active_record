# frozen_string_literal: true

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
