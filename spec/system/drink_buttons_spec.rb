require "rails_helper"

RSpec.describe "Drink Buttons" do
  let!(:sealed_sake) { create(:sake, bottle_level: "sealed") }
  let!(:opened_sake) { create(:sake, bottle_level: "opened") }
  let!(:impressed_sake) { create(:sake, bottle_level: "opened", taste_value: 1, aroma_value: 2) }
  let!(:empty_sake) { create(:sake, bottle_level: "empty", taste_value: 1, aroma_value: 2) }
  let(:user) { create(:user) }

  before do
    visit sakes_path
  end

  describe "drink button text in index page" do
    open_text = I18n.t("sakes.drink_button.open")
    impress_text = I18n.t("sakes.drink_button.impress")
    empty_text = I18n.t("sakes.drink_button.empty")

    describe "sealed bottle" do
      it "has open button with i18n text" do
        id = "sake_buttons_#{sealed_sake.id}"
        expect(find(:test_id, id)).to have_text(open_text)
      end

      it "has impress button with i18n text" do
        id = "sake_buttons_#{sealed_sake.id}"
        expect(find(:test_id, id)).to have_text(impress_text)
      end

      it "does not have empty button with i18n text" do
        id = "sake_buttons_#{sealed_sake.id}"
        expect(find(:test_id, id)).to have_no_text(empty_text)
      end
    end

    describe "opened and unimpressed bottle" do
      it "does not have open button with i18n text" do
        id = "sake_buttons_#{opened_sake.id}"
        expect(find(:test_id, id)).to have_no_text(open_text)
      end

      it "has impress button with i18n text" do
        id = "sake_buttons_#{opened_sake.id}"
        expect(find(:test_id, id)).to have_text(impress_text)
      end

      it "has empty button with i18n text" do
        id = "sake_buttons_#{opened_sake.id}"
        expect(find(:test_id, id)).to have_text(empty_text)
      end
    end

    describe "opened and impressed bottle" do
      it "does not have open button with i18n text" do
        id = "sake_buttons_#{impressed_sake.id}"
        expect(find(:test_id, id)).to have_no_text(open_text)
      end

      it "does not have impress button with i18n text" do
        id = "sake_buttons_#{impressed_sake.id}"
        expect(find(:test_id, id)).to have_no_text(impress_text)
      end

      it "has empty button with i18n text" do
        id = "sake_buttons_#{impressed_sake.id}"
        expect(find(:test_id, id)).to have_text(empty_text)
      end
    end

    describe "empty bottle" do
      before do
        page.check("check_empty_bottle")
        click_button("submit_search")
      end

      it "does not have open button with i18n text" do
        id = "sake_buttons_#{empty_sake.id}"
        expect(find(:test_id, id)).to have_no_text(open_text)
      end

      it "does not have impress button with i18n text" do
        id = "sake_buttons_#{empty_sake.id}"
        expect(find(:test_id, id)).to have_no_text(impress_text)
      end

      it "does not have empty button with i18n text" do
        id = "sake_buttons_#{empty_sake.id}"
        expect(find(:test_id, id)).to have_no_text(empty_text)
      end
    end
  end

  context "without login" do
    before do
      sign_out(user)
    end

    describe "clicking impress button of opened bottle" do
      it "redirects to user login page" do
        click_button "dropdown_toggle_#{opened_sake.id}"
        click_link "impress_button_#{opened_sake.id}"
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    describe "clicking open button of sealed bottle", js: true do
      before do
        click_button "dropdown_toggle_#{sealed_sake.id}"
        accept_confirm do
          click_link "open_button_#{sealed_sake.id}"
        end
        wait_for_page new_user_session_path
      end

      it "redirects to user login page" do
        expect(page).to have_current_path(new_user_session_path)
      end

      it "does not change bottle state after sign in" do
        signin_process_on_signin_page(user)
        expect { sealed_sake.reload }.not_to change(sealed_sake, :bottle_level)
      end
    end

    describe "clicking empty button of impressed bottle", js: true do
      before do
        click_button "dropdown_toggle_#{impressed_sake.id}"
        accept_confirm do
          click_link "empty_button_#{impressed_sake.id}"
        end
        wait_for_page new_user_session_path
      end

      it "redirects to user login page" do
        expect(page).to have_current_path(new_user_session_path)
      end

      it "does not change bottle state after sign in" do
        signin_process_on_signin_page(user)
        expect { impressed_sake.reload }.not_to change(sealed_sake, :bottle_level)
      end
    end
  end

  context "with login" do
    before do
      sign_in(user)
    end

    describe "clicking impress button of sealed bottle" do
      before do
        click_button "dropdown_toggle_#{sealed_sake.id}"
        click_link "open_and_impress_button_#{sealed_sake.id}"
      end

      it "redirects to sake edit page" do
        path = edit_sake_path(sealed_sake.id)
        # クエリ "?sake[bottle_level]=opened" 部を無視する
        expect(page).to have_current_path(path, ignore_query: true)
      end

      it "moves to edit page and has 'opened' state" do
        id = "sake_bottle_level"
        text = I18n.t("enums.sake.bottle_level.opened")
        expect(page).to have_select(id, selected: text)
      end
    end

    describe "clicking impress button of opened bottle" do
      before do
        click_button "dropdown_toggle_#{opened_sake.id}"
        click_link "impress_button_#{opened_sake.id}"
      end

      it "redirects to sake edit page" do
        path = edit_sake_path(opened_sake)
        expect(page).to have_current_path(path)
      end

      it "moves to edit page and keep 'opened' state" do
        id = "sake_bottle_level"
        text = I18n.t("enums.sake.bottle_level.opened")
        expect(page).to have_select(id, selected: text)
      end
    end

    describe "clicking open button of sealed bottle", js: true do
      before do
        click_button "dropdown_toggle_#{sealed_sake.id}"
        accept_confirm do
          click_link "open_button_#{sealed_sake.id}"
        end
        wait_for_alert
      end

      it "reloads index page" do
        expect(page).to have_current_path(sakes_path)
      end

      it "has success flash message" do
        text = I18n.t("sakes.update.success_open", name: sealed_sake.name)
        expect(find(:test_id, "flash_message")).to have_text(text)
      end

      it "has flash message containing link to updated sake" do
        expect(find(:test_id, "flash_message")).to have_link(sealed_sake.name, href: sake_path(sealed_sake.id))
      end

      it "updates sake to opened" do
        expect {
          sealed_sake.reload
        }.to change(sealed_sake, :bottle_level).from("sealed").to("opened")
      end
    end

    describe "clicking empty button of impressed bottle", js: true do
      before do
        click_button "dropdown_toggle_#{impressed_sake.id}"
        accept_confirm do
          click_link "empty_button_#{impressed_sake.id}"
        end
        wait_for_alert
      end

      it "reloads to index page" do
        expect(page).to have_current_path(sakes_path)
      end

      it "has success flash message" do
        text = I18n.t("sakes.update.success_empty", name: impressed_sake.name)
        expect(find(:test_id, "flash_message")).to have_text(text)
      end

      it "has flash message containing link to updated sake" do
        expect(find(:test_id, "flash_message")).to have_link(impressed_sake.name, href: sake_path(impressed_sake.id))
      end

      it "updates sake to empty" do
        expect {
          impressed_sake.reload
        }.to change(impressed_sake, :bottle_level).from("opened").to("empty")
      end
    end
  end
end
