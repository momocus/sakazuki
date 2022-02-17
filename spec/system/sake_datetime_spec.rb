require "rails_helper"

RSpec.describe "Sake DateTime" do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  delta = 1.second

  describe "create a new sake" do
    before do
      visit new_sake_path
      fill_in("sake_name", with: "生道井")
    end

    context "for sealed sake" do
      it "creates the sake whoes created_at is close to now" do
        click_button("form-submit")
        created_at = sake_from_show_path(page.current_path).created_at
        now = Time.current
        expect(created_at).to be_within(delta).of(now)
      end
    end

    context "for opened sake" do
      before do
        select(I18n.t("enums.sake.bottle_level.opened"), from: "sake_bottle_level")
        click_button("form-submit")
      end

      it "creates the sake whoes created_at is close to now" do
        created_at = sake_from_show_path(page.current_path).created_at
        now = Time.current
        expect(created_at).to be_within(delta).of(now)
      end

      it "creates the sake whoes opened_at is close to now" do
        opened_at = sake_from_show_path(page.current_path).opened_at
        now = Time.current
        expect(opened_at).to be_within(delta).of(now)
      end
    end

    context "for emptied sake" do
      before do
        select(I18n.t("enums.sake.bottle_level.empty"), from: "sake_bottle_level")
        click_button("form-submit")
      end

      it "creates the sake whoes created_at is close to now" do
        created_at = sake_from_show_path(page.current_path).created_at
        now = Time.current
        expect(created_at).to be_within(delta).of(now)
      end

      it "creates the sake whoes opened_at is close to now" do
        opened_at = sake_from_show_path(page.current_path).opened_at
        now = Time.current
        expect(opened_at).to be_within(delta).of(now)
      end

      it "creates the sake whoes emptied_at is close to now" do
        emptied_at = sake_from_show_path(page.current_path).emptied_at
        now = Time.current
        expect(emptied_at).to be_within(delta).of(now)
      end
    end
  end

  describe "open the sealed sake" do
    created_at = Time.current.ago(7.days)
    let(:sake) { FactoryBot.create(:sake, bottle_level: "sealed", created_at: created_at) }

    before do
      visit edit_sake_path(sake.id)
      select(I18n.t("enums.sake.bottle_level.opened"), from: "sake_bottle_level")
      click_button("form-submit")
    end

    it "does not change created_at" do
      new_created_at = sake.created_at
      expect(new_created_at).to be_within(delta).of(created_at)
    end

    it "changes opened_at to be close to now" do
      opened_at = sake.opened_at
      now = Time.current
      expect(opened_at).to be_within(delta).of(now)
    end
  end

  describe "empty the sake" do
    context "for sealed sake" do
      created_at = Time.current.ago(7.days)
      let(:sake) { FactoryBot.create(:sake, bottle_level: "sealed", created_at: created_at) }

      it "does not change created_at" do
        new_created_at = sake.created_at
        expect(new_created_at).to be_within(delta).of(created_at)
      end

      it "changes opened_at to be close to now" do
        opened_at = sake.opened_at
        now = Time.current
        expect(opened_at).to be_within(delta).of(now)
      end

      it "changes emptied_at to be close to now" do
        emptied_at = sake.emptied_at
        now = Time.current
        expect(emptied_at).to be_within(delta).of(now)
      end
    end

    context "for opened sake" do
      created_at = Time.current.ago(7.days)
      opened_at = Time.current.ago(4.days)
      let(:sake) { FactoryBot.create(:sake, bottle_level: "sealed", created_at: created_at, opened_at: opened_at) }

      it "does not change created_at" do
        new_created_at = sake.created_at
        expect(new_created_at).to be_within(delta).of(created_at)
      end

      it "does not change opened_at" do
        new_opened_at = sake.opened_at
        expect(new_opened_at).to be_within(delta).of(opened_at)
      end

      it "changes emptied_at to be close to now" do
        emptied_at = sake.emptied_at
        now = Time.current
        expect(emptied_at).to be_within(delta).of(now)
      end
    end
  end
end
