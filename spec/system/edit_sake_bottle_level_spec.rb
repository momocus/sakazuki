require "rails_helper"

RSpec.describe "Edit Sake's Bottle Level" do
  let(:user) { FactoryBot.create(:user) }
  let(:sealed_sake) { FactoryBot.create(:sake, bottle_level: :sealed) }
  let(:opened_sake) { FactoryBot.create(:sake, bottle_level: :opened) }
  let(:empty_sake) { FactoryBot.create(:sake, bottle_level: :empty) }

  before do
    sign_in(user)
  end

  context "when usual updating" do
    describe "updating sake from sealed to opened" do
      before do
        visit edit_sake_path(sealed_sake.id)
        select(I18n.t("enums.sake.bottle_level.opened"), from: "select-bottle-level")
        click_button("form-submit")
      end

      it "update bottle level to open" do
        expect { sealed_sake.reload }.to change(sealed_sake, :bottle_level).from("sealed").to("opened")
      end

      it "does not update created_at" do
        expect { sealed_sake.reload }.not_to change(sealed_sake, :created_at)
      end

      it "updates opened_at" do
        expect { sealed_sake.reload }.to change(sealed_sake, :opened_at)
      end

      it "does not update emptied_at" do
        expect { sealed_sake.reload }.not_to change(sealed_sake, :emptied_at)
      end

      it "updates updated_at" do
        expect { sealed_sake.reload }.to change(sealed_sake, :updated_at)
      end

      it "hase close date time between updated_at and updated_at" do
        sealed_sake.reload
        delta = 1.second        # 差分が1秒以内
        expect(sealed_sake.opened_at).to be_within(delta).of(sealed_sake.updated_at)
      end
    end

    describe "updating sake from sealed to empty" do
      before do
        visit edit_sake_path(sealed_sake.id)
        select(I18n.t("enums.sake.bottle_level.empty"), from: "select-bottle-level")
        click_button("form-submit")
      end

      it "update bottle level to empty" do
        expect { sealed_sake.reload }.to change(sealed_sake, :bottle_level).from("sealed").to("empty")
      end

      it "updates updated_at" do
        expect { sealed_sake.reload }.to change(sealed_sake, :updated_at)
      end

      it "updates opened_at" do
        expect { sealed_sake.reload }.to change(sealed_sake, :opened_at)
      end

      it "updates emptied_at" do
        expect { sealed_sake.reload }.to change(sealed_sake, :emptied_at)
      end

      it "does not update created_at" do
        expect { sealed_sake.reload }.not_to change(sealed_sake, :created_at)
      end

      it "hase close date time between opened_at and updated_at" do
        sealed_sake.reload
        delta = 1.second        # 差分が1秒以内
        expect(sealed_sake.opened_at).to be_within(delta).of(sealed_sake.updated_at)
      end

      it "hase close date time between emptied_at and updated_at" do
        sealed_sake.reload
        delta = 1.second        # 差分が1秒以内
        expect(sealed_sake.emptied_at).to be_within(delta).of(sealed_sake.updated_at)
      end
    end

    describe "updating sake from opened to empty" do
      before do
        visit edit_sake_path(opened_sake.id)
        select(I18n.t("enums.sake.bottle_level.empty"), from: "select-bottle-level")
        click_button("form-submit")
      end

      it "update bottle level to empty" do
        expect { opened_sake.reload }.to change(opened_sake, :bottle_level).from("opened").to("empty")
      end

      it "does not update created_at" do
        expect { opened_sake.reload }.not_to change(opened_sake, :created_at)
      end

      it "does not update opened_at" do
        expect { opened_sake.reload }.not_to change(opened_sake, :opened_at)
      end

      it "updates emptied_at" do
        expect { opened_sake.reload }.to change(opened_sake, :emptied_at)
      end

      it "updates updated_at" do
        expect { opened_sake.reload }.to change(opened_sake, :updated_at)
      end

      it "hase same date time between updated_at and emptied_at" do
        opened_sake.reload
        delta = 1.second        # 差分が1秒以内
        expect(opened_sake.emptied_at).to be_within(delta).of(opened_sake.updated_at)
      end
    end
  end

  context "when anusual updating" do
    describe "updating sake from empty to sealed" do
      before do
        visit edit_sake_path(empty_sake.id)
        select(I18n.t("enums.sake.bottle_level.sealed"), from: "select-bottle-level")
        click_button("form-submit")
      end

      it "update bottle level to sealed" do
        expect { empty_sake.reload }.to change(empty_sake, :bottle_level).from("empty").to("sealed")
      end

      it "does not update created_at" do
        expect { empty_sake.reload }.not_to change(empty_sake, :created_at)
      end

      it "does not update opened_at" do
        expect { empty_sake.reload }.not_to change(empty_sake, :opened_at)
      end

      it "does not update emptied_at" do
        expect { empty_sake.reload }.not_to change(empty_sake, :emptied_at)
      end

      it "updates updated_at" do
        expect { empty_sake.reload }.to change(empty_sake, :updated_at)
      end
    end

    describe "updating sake from empty to opened" do
      before do
        visit edit_sake_path(empty_sake.id)
        select(I18n.t("enums.sake.bottle_level.opened"), from: "select-bottle-level")
        click_button("form-submit")
      end

      it "update bottle level to opened" do
        expect { empty_sake.reload }.to change(empty_sake, :bottle_level).from("empty").to("opened")
      end

      it "does not update created_at" do
        expect { empty_sake.reload }.not_to change(empty_sake, :created_at)
      end

      it "does not update opened_at" do
        expect { empty_sake.reload }.not_to change(empty_sake, :opened_at)
      end

      it "does not update emptied_at" do
        expect { empty_sake.reload }.not_to change(empty_sake, :emptied_at)
      end

      it "updates updated_at" do
        expect { empty_sake.reload }.to change(empty_sake, :updated_at)
      end
    end

    describe "updating sake from opened to sealed" do
      before do
        visit edit_sake_path(opened_sake.id)
        select(I18n.t("enums.sake.bottle_level.sealed"), from: "select-bottle-level")
        click_button("form-submit")
      end

      it "update bottle level to sealed" do
        expect { opened_sake.reload }.to change(opened_sake, :bottle_level).from("opened").to("sealed")
      end

      it "does not update created_at" do
        expect { opened_sake.reload }.not_to change(opened_sake, :created_at)
      end

      it "does not update opened_at" do
        expect { opened_sake.reload }.not_to change(opened_sake, :opened_at)
      end

      it "does not update emptied_at" do
        expect { opened_sake.reload }.not_to change(opened_sake, :emptied_at)
      end

      it "updates updated_at" do
        expect { opened_sake.reload }.to change(opened_sake, :updated_at)
      end
    end
  end
end
