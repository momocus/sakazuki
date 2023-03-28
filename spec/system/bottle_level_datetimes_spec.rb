require "rails_helper"

RSpec.describe "Bottle Level Datetimes" do
  let(:user) { create(:user) }

  delta = 1.second

  before do
    sign_in(user)
  end

  context "when creating a new sealed sake" do
    before do
      visit new_sake_path
      fill_in("sake_name", with: "生道井")
      select(I18n.t("enums.sake.bottle_level.sealed"), from: "sake_bottle_level")
      click_button("form_submit")
    end

    describe "created_at" do
      it "is close to now" do
        created_at = sake_from_show_path(page.current_path).created_at
        now = Time.current
        expect(created_at).to be_within(delta).of(now)
      end
    end
  end

  context "when creating a new opened sake" do
    before do
      visit new_sake_path
      fill_in("sake_name", with: "生道井")
      select(I18n.t("enums.sake.bottle_level.opened"), from: "sake_bottle_level")
      click_button("form_submit")
    end

    describe "created_at" do
      it "is close to now" do
        created_at = sake_from_show_path(page.current_path).created_at
        now = Time.current
        expect(created_at).to be_within(delta).of(now)
      end
    end

    describe "opened_at" do
      it "is close to now" do
        opened_at = sake_from_show_path(page.current_path).opened_at
        now = Time.current
        expect(opened_at).to be_within(delta).of(now)
      end
    end
  end

  context "when creating a new empty sake" do
    before do
      visit new_sake_path
      fill_in("sake_name", with: "生道井")
      select(I18n.t("enums.sake.bottle_level.empty"), from: "sake_bottle_level")
      click_button("form_submit")
    end

    describe "created_at" do
      it "is close to now" do
        created_at = sake_from_show_path(page.current_path).created_at
        now = Time.current
        expect(created_at).to be_within(delta).of(now)
      end
    end

    describe "opened_at" do
      it "is close to now" do
        opened_at = sake_from_show_path(page.current_path).opened_at
        now = Time.current
        expect(opened_at).to be_within(delta).of(now)
      end
    end

    describe "emptied_at" do
      it "is close to now" do
        emptied_at = sake_from_show_path(page.current_path).emptied_at
        now = Time.current
        expect(emptied_at).to be_within(delta).of(now)
      end
    end
  end

  context "when opening a sealed sake" do
    created_at = 7.days.ago
    let(:sake) { create(:sake, bottle_level: "sealed", created_at:) }

    before do
      visit edit_sake_path(sake.id)
      select(I18n.t("enums.sake.bottle_level.opened"), from: "sake_bottle_level")
      click_button("form_submit")
    end

    describe "created_at" do
      it "is not changed" do
        expect { sake.reload }.not_to change(sake, :created_at)
      end
    end

    describe "opened_at" do
      it "is changed to close to now" do
        opened_at = sake.opened_at
        now = Time.current
        expect(opened_at).to be_within(delta).of(now)
      end
    end
  end

  context "when empting a sealed sake" do
    created_at = 7.days.ago
    let(:sake) { create(:sake, bottle_level: "sealed", created_at:) }

    before do
      visit edit_sake_path(sake.id)
      select(I18n.t("enums.sake.bottle_level.empty"), from: "sake_bottle_level")
      click_button("form_submit")
    end

    describe "created_at" do
      it "is not changed" do
        expect { sake.reload }.not_to change(sake, :created_at)
      end
    end

    describe "opened_at" do
      it "is changed to close to now" do
        opened_at = sake.opened_at
        now = Time.current
        expect(opened_at).to be_within(delta).of(now)
      end
    end

    describe "emptied_at" do
      it "is changed to close to now" do
        emptied_at = sake.emptied_at
        now = Time.current
        expect(emptied_at).to be_within(delta).of(now)
      end
    end
  end

  context "when empting a opened sake" do
    created_at = 7.days.ago
    opened_at = 4.days.ago
    let(:sake) { create(:sake, bottle_level: "opened", created_at:, opened_at:) }

    before do
      visit edit_sake_path(sake.id)
      select(I18n.t("enums.sake.bottle_level.empty"), from: "sake_bottle_level")
      click_button("form_submit")
    end

    describe "created_at" do
      it "is not changed" do
        expect { sake.reload }.not_to change(sake, :created_at)
      end
    end

    describe "opened_at" do
      it "is not changed" do
        expect { sake.reload }.not_to change(sake, :opened_at)
      end
    end

    describe "emptied_at" do
      it "is changed to close to now" do
        emptied_at = sake.emptied_at
        now = Time.current
        expect(emptied_at).to be_within(delta).of(now)
      end
    end
  end

  context "when updating the name of the sealed sake" do
    let!(:sake) { create(:sake, bottle_level: :sealed, opened_at: Date.new(2000, 1, 1)) }

    before do
      visit(edit_sake_path(sake.id))
      fill_in("sake_name",	with: "衣が浦若水　純米大吟醸")
      click_button("form_submit")
    end

    it "does not changed the opened_at" do
      expect { sake.reload }.not_to change(sake, :opened_at)
    end

    it "does not changed the emptied_at" do
      expect { sake.reload }.not_to change(sake, :emptied_at)
    end
  end

  context "when updating the name of the opened sake" do
    let(:sake) { create(:sake, bottle_level: :opened) }

    before do
      visit(edit_sake_path(sake.id))
      fill_in("sake_name",	with: "updated-sake-name")
      click_button("form_submit")
    end

    it "does not changed the opened_at" do
      expect { sake.reload }.not_to change(sake, :opened_at)
    end

    it "does not changed the emptied_at" do
      expect { sake.reload }.not_to change(sake, :emptied_at)
    end
  end

  context "when updating the name of the emptied sake" do
    let(:sake) { create(:sake, bottle_level: :empty) }

    before do
      visit(edit_sake_path(sake.id))
      fill_in("sake_name",	with: "updated-sake-name")
      click_button("form_submit")
    end

    it "does not changed the opened_at" do
      expect { sake.reload }.not_to change(sake, :opened_at)
    end

    it "does not changed the emptied_at" do
      expect { sake.reload }.not_to change(sake, :emptied_at)
    end
  end
end
