require "rails_helper"

RSpec.describe "New Sake's Date and Time" do
  let(:user) { FactoryBot.create(:user) }

  some_date = %r{[0-9]+/[0-9]+/[0-9]+}

  before do
    sign_in(user)
    visit new_sake_path
    fill_in("textfield-name", with: "new sake name")
  end

  describe "creating sealed sake" do
    before do
      select(I18n.t("enums.sake.bottle_level.sealed"), from: "select-bottle-level")
      click_button("form-submit")
    end

    it "creates sake having created_at" do
      created_at = find(:test_id, "created-at").text
      expect(created_at).to have_text(some_date)
    end

    it "creates sake not having opened_at" do
      expect(find(:test_id, "opened-at")).not_to have_text(some_date)
    end

    it "creates sake not having emptied_at" do
      expect(find(:test_id, "emptied-at")).not_to have_text(some_date)
    end

    it "creates sake having updated_at" do
      updated_at = find(:test_id, "updated-at").text
      expect(updated_at).to have_text(some_date)
    end

    it "creates sake having close date between created_at and updated_at" do
      created_at = DateTime.parse(find(:test_id, "created-at").text)
      updated_at = DateTime.parse(find(:test_id, "updated-at").text)
      delta = 1.second
      expect(updated_at).to be_within(delta).of(created_at)
    end
  end

  describe "creating opened sake" do
    before do
      select(I18n.t("enums.sake.bottle_level.opened"), from: "select-bottle-level")
      click_button("form-submit")
    end

    it "creates sake having created_at" do
      created_at = find(:test_id, "created-at").text
      expect(created_at).to have_text(some_date)
    end

    it "creates sake having opened_at" do
      expect(find(:test_id, "opened-at")).to have_text(some_date)
    end

    it "creates sake not having emptied_at" do
      expect(find(:test_id, "emptied-at")).not_to have_text(some_date)
    end

    it "creates sake having updated_at" do
      updated_at = find(:test_id, "updated-at").text
      expect(updated_at).to have_text(some_date)
    end

    it "creates sake having close date between created_at and opened_at" do
      created_at = DateTime.parse(find(:test_id, "created-at").text)
      updated_at = DateTime.parse(find(:test_id, "opened-at").text)
      delta = 1.second
      expect(updated_at).to be_within(delta).of(created_at)
    end

    it "creates sake having close date between created_at and updated_at" do
      created_at = DateTime.parse(find(:test_id, "created-at").text)
      updated_at = DateTime.parse(find(:test_id, "updated-at").text)
      delta = 1.second
      expect(updated_at).to be_within(delta).of(created_at)
    end
  end

  describe "creating empty sake" do
    before do
      select(I18n.t("enums.sake.bottle_level.empty"), from: "select-bottle-level")
      click_button("form-submit")
    end

    it "creates sake having created_at" do
      created_at = find(:test_id, "created-at").text
      expect(created_at).to have_text(some_date)
    end

    it "creates sake having opened_at" do
      expect(find(:test_id, "opened-at")).to have_text(some_date)
    end

    it "creates sake having emptied_at" do
      expect(find(:test_id, "emptied-at")).to have_text(some_date)
    end

    it "creates sake having updated_at" do
      updated_at = find(:test_id, "updated-at").text
      expect(updated_at).to have_text(some_date)
    end

    it "creates sake having close date between created_at and opened_at" do
      created_at = DateTime.parse(find(:test_id, "created-at").text)
      updated_at = DateTime.parse(find(:test_id, "opened-at").text)
      delta = 1.second
      expect(updated_at).to be_within(delta).of(created_at)
    end

    it "creates sake having close date between created_at and emptied_at" do
      created_at = DateTime.parse(find(:test_id, "created-at").text)
      updated_at = DateTime.parse(find(:test_id, "emptied-at").text)
      delta = 1.second
      expect(updated_at).to be_within(delta).of(created_at)
    end

    it "creates sake having close date between created_at and updated_at" do
      created_at = DateTime.parse(find(:test_id, "created-at").text)
      updated_at = DateTime.parse(find(:test_id, "updated-at").text)
      delta = 1.second
      expect(updated_at).to be_within(delta).of(created_at)
    end
  end
end
