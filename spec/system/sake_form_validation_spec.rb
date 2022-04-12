require "rails_helper"

RSpec.describe "Sake Form Validation" do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    visit new_sake_path
    fill_in("sake_name", with: "生道井")
  end

  describe "flash message" do
    context "with invalid value" do
      before do
        fill_in("sake_alcohol", with: "-10")
        click_button("form_submit")
      end

      it "has flash message" do
        expect(page).to have_selector(:test_id, "flash_message")
      end

      it "has error flash message" do
        expect(page).to have_css(".alert-danger")
      end

      it "has error message" do
        text = I18n.t("sakes.form.input_error")
        expect(find(:test_id, "flash_message")).to have_text(text)
      end
    end
  end

  describe "name", js: true do
    context "with empty string" do
      before do
        fill_in("sake_name", with: "")
        click_button("form_submit")
      end

      it "do not move page" do
        expect(page).to have_current_path(new_sake_path)
      end
    end
  end

  describe "alcohol" do
    context "with minus value" do
      before do
        fill_in("sake_alcohol", with: "-1")
        click_button("form_submit")
      end

      it "has style for invalid" do
        expect(find(:test_id, "sake_alcohol").first(:xpath, "..")).to have_css(".is-invalid")
      end

      it "has error message" do
        expect(page).to have_selector(:test_id, "sake_alcohol_feedback")
      end
    end

    context "with value over 100" do
      before do
        fill_in("sake_alcohol", with: "101")
        click_button("form_submit")
      end

      it "has style for invalid" do
        expect(find(:test_id, "sake_alcohol").first(:xpath, "..")).to have_css(".is-invalid")
      end

      it "has error message" do
        expect(page).to have_selector(:test_id, "sake_alcohol_feedback")
      end
    end
  end

  describe "seimai_buai" do
    context "with minus value" do
      before do
        fill_in("sake_seimai_buai", with: "-1")
        click_button("form_submit")
      end

      it "has style for invalid" do
        expect(find(:test_id, "sake_seimai_buai").first(:xpath, "..")).to have_css(".is-invalid")
      end

      it "has error message" do
        expect(page).to have_selector(:test_id, "sake_seimai_buai_feedback")
      end
    end

    context "with value over 100" do
      before do
        fill_in("sake_seimai_buai", with: "101")
        click_button("form_submit")
      end

      it "has style for invalid" do
        expect(find(:test_id, "sake_seimai_buai").first(:xpath, "..")).to have_css(".is-invalid")
      end

      it "has error message" do
        expect(page).to have_selector(:test_id, "sake_seimai_buai_feedback")
      end
    end
  end

  describe "size" do
    context "with minus value" do
      before do
        fill_in("sake_size", with: "-1")
        click_button("form_submit")
      end

      it "has style for invalid" do
        expect(find(:test_id, "sake_size").first(:xpath, "..")).to have_css(".is-invalid")
      end

      it "has error message" do
        expect(page).to have_selector(:test_id, "sake_size_feedback")
      end
    end
  end

  describe "price" do
    context "with minus value" do
      before do
        fill_in("sake_price", with: "-1")
        click_button("form_submit")
      end

      it "has style for invalid" do
        expect(find(:test_id, "sake_price").first(:xpath, "..")).to have_css(".is-invalid")
      end

      it "has error message" do
        expect(page).to have_selector(:test_id, "sake_price_feedback")
      end
    end
  end

  describe "sando" do
    context "with minus value" do
      before do
        fill_in("sake_sando", with: "-1.0")
        click_button("form_submit")
      end

      it "has style for invalid" do
        expect(find(:test_id, "sake_sando").first(:xpath, "..")).to have_css(".is-invalid")
      end

      it "has error message" do
        expect(page).to have_selector(:test_id, "sake_sando_feedback")
      end
    end
  end

  describe "aminosando" do
    context "with minus value" do
      before do
        fill_in("sake_aminosando", with: "-1.0")
        click_button("form_submit")
      end

      it "has style for invalid" do
        expect(find(:test_id, "sake_aminosando").first(:xpath, "..")).to have_css(".is-invalid")
      end

      it "has error message" do
        expect(page).to have_selector(:test_id, "sake_aminosando_feedback")
      end
    end
  end
end
