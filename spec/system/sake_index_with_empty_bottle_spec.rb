require "rails_helper"

RSpec.describe "With Empty Bottle" do
  # 変数内を呼び出す前にページにアクセスするため、let!で確実に生成する
  let!(:sealed) { create(:sake, name: "未開封のお酒", bottle_level: "sealed") }
  let!(:opened) { create(:sake, name: "開封済みのお酒", bottle_level: "opened") }
  let!(:empty) { create(:sake, name: "空のお酒", bottle_level: "empty") }

  before do
    visit sakes_path
  end

  describe "switch to include empty bottle" do
    context "when access sake index" do
      it "is false" do
        label = I18n.t("sakes.index.all_bottles")
        checkbox = find(:test_id, "check_empty_bottle")
        expect(checkbox).to have_no_checked_field(label)
      end
    end
  end

  describe "listed sakes" do
    context "without empty bottles" do
      it "includes sealed sake" do
        regexp = /#{sealed.name}/
        expect(page.text).to match(regexp)
      end

      it "includes opened sake" do
        regexp = /#{opened.name}/
        expect(page.text).to match(regexp)
      end

      it "does not include empty sake" do
        regexp = /#{empty.name}/
        expect(page.text).not_to match(regexp)
      end
    end
  end

  context "with empty bottles", :js do
    before do
      label = I18n.t("sakes.index.all_bottles")
      check(label)
    end

    context "without empty bottles" do
      it "includes sealed sake" do
        regexp = /#{sealed.name}/
        expect(page.text).to match(regexp)
      end

      it "includes opened sake" do
        regexp = /#{opened.name}/
        expect(page.text).to match(regexp)
      end

      it "includes empty sake" do
        regexp = /#{empty.name}/
        expect(page.text).to match(regexp)
      end
    end
  end
end
