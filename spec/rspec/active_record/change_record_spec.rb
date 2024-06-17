# frozen_string_literal: true

RSpec.describe RSpec::ActiveRecord::ChangeRecord do
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
    it "matches when record is changed" do
      expect { user.update!(name: "changed") }.to change_record(user).to(name: "changed")
    end

    it "doesn't match when at least one attribute did not change" do
      user.update!(name: "changed")
      expect do
        expect { user.update!(email: "user@example.com") }
          .to change_record(user).to(name: "changed", email: "user@example.com")
      end.to fail_with(<<~MSG.chomp)
        expected User#1 to not match {:email => "user@example.com", :name => "changed"} initially but it did
      MSG
    end

    it "doesn't match when record is not changed" do
      expect do
        expect { user.assign_attributes(name: "changed") }.to change_record(user).to(name: "changed")
      end.to fail_with(<<~MSG.chomp)
        expected to change User#1 to {:name => "changed"} but did not

        Diff for User#1

        @@ -1 +1 @@
        -:name => "changed",
        +:name => "initial",

      MSG
    end

    it "matches when record change from initial" do
      expect { user.update!(name: "changed") }.to change_record(user).from(name: "initial")
    end

    it "doesn't match when record did not change from initial" do
      expect do
        expect { user.assign_attributes(name: "changed") }.to change_record(user).from(name: "initial")
      end.to fail_with(<<~MSG.chomp)
        expected to change User#1 from {:name => "initial"} but did not
      MSG
    end

    it "doesn't match when record did not match initial attributes" do
      expect do
        expect { user.assign_attributes(name: "changed") }.to change_record(user).from(name: "changed")
      end.to fail_with(<<~MSG.chomp)
        expected User#1 to match {:name => "changed"} initially but it did not

        Diff for User#1

        @@ -1 +1 @@
        -:name => "changed",
        +:name => "initial",

      MSG
    end

    it "doesn't match if from or to is not specified" do
      expect do
        expect { user.update!(name: "changed") }.to change_record(user)
      end.to fail_with(<<~MSG.chomp)
        please specify from or to for change_record
      MSG
    end
  end

  describe "negative matcher" do
    it "matches when record is not changed" do
      expect { user.assign_attributes(name: "changed") }.to not_change_record(user).from(name: "initial")
    end

    it "doesn't match when record changed from initial" do
      expect do
        expect { user.update!(name: "changed") }.to not_change_record(user).from(name: "initial")
      end.to fail_with(<<~MSG.chomp)
        expected not to change User#1 from {:name => "initial"} but it did
      MSG
    end

    it "doesn't match when record did not match initial attributes" do
      expect do
        expect { user.assign_attributes(name: "changed") }.to not_change_record(user).from(name: "changed")
      end.to fail_with(<<~MSG.chomp)
        expected User#1 to match {:name => "changed"} initially but it did not

        Diff for User#1

        @@ -1 +1 @@
        -:name => "changed",
        +:name => "initial",

      MSG
    end

    it "doesn't match when from is not specified" do
      expect do
        expect { user.update!(name: "changed") }.to not_change_record(user)
      end.to fail_with(<<~MSG.chomp)
        negative matcher for change_record without from is not supported
      MSG
    end

    it "doesn't match when to is specified" do
      expect do
        expect { user.update!(name: "changed") }.to not_change_record(user).from(name: "initial").to(name: "changed")
      end.to fail_with(<<~MSG.chomp)
        negative matcher for change_record with to is not supported
      MSG
    end
  end
end
