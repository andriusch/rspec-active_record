# frozen_string_literal: true

RSpec.describe RSpec::ActiveRecord::DestroyRecord do
  let(:user) { User.create!(name: "initial") }

  before do
    create_temporary_table :users do |t|
      t.string :name
      t.string :email
    end

    stub_model :User do
      scope :named, -> { where.not(name: nil) }
    end
  end

  describe "positive matcher" do
    it "matches when record is destroyed" do
      expect { user.destroy! }.to destroy_record(user)
    end

    it "doesn't match when record is not destroyed" do
      user.update!(name: "changed")
      expect do
        expect { user.save! }.to destroy_record(user)
      end.to fail_with(<<~MSG.chomp)
        expected to destroy User#1 but did not
      MSG
    end
  end

  describe "negative matcher" do
    it "matches when record is destroyed" do
      expect { user.save! }.to not_destroy_record(user)
    end

    it "doesn't match when record is not destroyed" do
      user.update!(name: "changed")
      expect do
        expect { user.destroy! }.to not_destroy_record(user)
      end.to fail_with(<<~MSG.chomp)
        expected not to destroy User#1 but did
      MSG
    end
  end
end
