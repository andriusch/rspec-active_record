# frozen_string_literal: true

RSpec.describe RSpec::ActiveRecord::DiffForMultipleRecords do
  subject(:diff) { described_class.new(attributes, [andrius, john]) }
  let(:attributes) { { name: "Dan" } }
  let(:andrius) { User.create!(name: "Andrius") }
  let(:john) { User.create!(name: "John") }

  before do
    create_temporary_table :users do |t|
      t.string :name
    end
    stub_model :User
  end

  describe "#call" do
    subject { diff.call }

    it { is_expected.to eq(<<~MSG.chomp) }
      Diff for User##{andrius.id}

      @@ -1 +1 @@
      -:name => \"Dan\",
      +:name => \"Andrius\",


      Diff for User##{john.id}

      @@ -1 +1 @@
      -:name => \"Dan\",
      +:name => \"John\",

    MSG
  end
end
