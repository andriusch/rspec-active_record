# frozen_string_literal: true

RSpec.describe RSpec::ActiveRecord::StubModels do
  describe "#stub_class" do
    subject do
      stub_class :User do
        def self.dummy_method
          "Dummy Name"
        end
      end
    end

    it do
      is_expected.to be_a(Class)
        .and have_attributes(name: "User", dummy_method: "Dummy Name")
    end
  end

  describe "#stub_model" do
    subject do
      stub_model :User do
        def self.dummy_method
          "Dummy Name"
        end
      end
    end

    it do
      is_expected.to be_a(Class)
        .and have_attributes(
          name: "User",
          superclass: ApplicationRecord,
          table_name: "users",
          dummy_method: "Dummy Name"
        )
    end

    context "without block" do
      subject { stub_model :User }

      it do
        is_expected.to be_a(Class)
          .and have_attributes(
            name: "User",
            superclass: ApplicationRecord,
            table_name: "users"
          )
      end
    end
  end

  describe "#create_temporary_table" do
    let(:connection) { ApplicationRecord.connection }

    it "creates empty table" do
      create_temporary_table :dummy_tables
      expect(connection.tables).to eq(%w[dummy_tables])
      expect(connection.columns(:dummy_tables).map(&:name)).to eq(%w[id])

      stub_model(:DummyTable)
      dummy = DummyTable.create!
      expect(DummyTable.all).to contain_exactly(dummy)
    end

    it "creates table with a column an no id" do
      create_temporary_table :dummy_tables, id: false do |t|
        t.string :uuid
      end
      expect(connection.tables).to eq(%w[dummy_tables])
      expect(connection.columns(:dummy_tables).map(&:name)).to eq(%w[uuid])

      stub_model(:DummyTable)
      DummyTable.create!(uuid: "my_uuid")
      expect(DummyTable.all).to contain_exactly(have_attributes(uuid: "my_uuid"))
    end
  end
end
