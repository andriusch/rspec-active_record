# frozen_string_literal: true

RSpec.describe RSpec::ActiveRecord::CreateRecord do
  before do
    create_temporary_table :users do |t|
      t.string :name
    end

    stub_model :User do
      scope :named, -> { where.not(name: nil) }
    end
  end

  it "matches when record is created" do
    expect { User.create! }.to create_record(User)
  end

  it "doesn't match when record is not created" do
    expect do
      expect { User.new }.to create_record(User)
    end.to fail_with("expected to create User but did not")
  end

  it "doesn't match when record was created outside of block" do
    User.create!
    expect do
      expect { User.new }.to create_record(User)
    end.to fail_with("expected to create User but did not")
  end

  it "matches when record is created in scope" do
    expect { User.create!(name: "Dummy") }.to create_record(User.named)
  end

  it "doesn't match when record is not created in scope" do
    expect do
      expect { User.create!(name: nil) }.to create_record(User.named)
    end.to fail_with("expected to create User but did not")
  end

  it "matches when record is created with matching attributes" do
    expect { User.create!(name: "Daniel") }.to create_record(User).matching(name: include("Dan"))
  end

  it "doesn't match when record is created with not matching attributes" do
    expect do
      expect { User.create!(name: "Andrius") }.to create_record(User).matching(name: include("Dan"))
    end.to fail_with(<<~MSG.chomp)
      expected to create User matching {:name => (include "Dan")} but did not

      Diff for User#1

      @@ -1 +1 @@
      -:name => (include \"Dan\"),
      +:name => \"Andrius\",

    MSG
  end

  it "matches when record is not created" do
    expect { User.new }.not_to create_record(User)
  end

  it "doesn't match when record is created" do
    expect do
      expect { User.create! }.not_to create_record(User)
    end.to fail_with("expected not to create User but did")
  end
end
