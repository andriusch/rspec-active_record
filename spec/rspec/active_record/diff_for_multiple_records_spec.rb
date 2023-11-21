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

  describe '#call' do
    subject { diff.call }

    it { is_expected.to eq(<<~MSG.chomp) }
      Diff for User##{andrius.id}
      \e[0m
      \e[0m\e[34m@@ -1 +1 @@
      \e[0m\e[31m-:name => \"Dan\",
      \e[0m\e[32m+:name => \"Andrius\",
      \e[0m

      Diff for User##{john.id}
      \e[0m
      \e[0m\e[34m@@ -1 +1 @@
      \e[0m\e[31m-:name => \"Dan\",
      \e[0m\e[32m+:name => \"John\",
      \e[0m
    MSG
  end
end
