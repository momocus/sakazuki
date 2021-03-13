require "rails_helper"

RSpec.describe "DrinkButtons", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:sake_sealed) { FactoryBot.create(:sake, bottle_level: "sealed") }
  let!(:sake_opened) { FactoryBot.create(:sake, bottle_level: "opened") }

  describe "sake column" do
    before do
      visit sakes_path
    end

    describe "sealed bottle column" do
      it "has button to open bottle" do
        state = I18n.t("enums.sake.bottle_level.sealed")
        link = I18n.t("sakes.index.open")
        expect(find("td", text: state, match: :first)).to have_link(link)
      end
    end

    describe "opened bottle column" do
      it "has button to make bottle empty" do
        state = I18n.t("enums.sake.bottle_level.opened")
        link = I18n.t("sakes.index.empty")
        expect(find("td", text: state, match: :first)).to have_link(link)
      end
    end
  end

  context "without login" do
    before do
      visit sakes_path
    end

    describe "clicking button to open bottle" do
      it "redirects to user login page" do
        click_link "open-#{sake_sealed.id}"
        expect(page).to have_current_path new_user_session_path
      end
    end

    describe "clicking button to make bottle empty" do
      it "redirects to user login page" do
        click_link "empty-#{sake_opened.id}"
        expect(page).to have_current_path new_user_session_path
      end
    end
  end

  context "with login" do
    before do
      user = FactoryBot.create(:user)
      sign_in(user)
    end

    describe "clicking button to open bottle" do
      before do
        visit sakes_path
        click_link "open-#{sake_sealed.id}"
      end

      it "redirects to sake edit page" do
        expect(page).to have_current_path "/sakes/#{sake_sealed.id}/edit?sake[bottle_level]=opened"
      end

      it "moves to edit page and has 'opened' state at satate of sake" do
        expect(page).to have_select("sake_bottle_level", selected: I18n.t("enums.sake.bottle_level.opened"))
      end
    end

    describe "clicking button to make bottle empty" do
      before do
        Capybara.current_driver = :selenium_headless
        visit sakes_path
        accept_confirm do
          click_link "empty-#{sake_opened.id}"
        end
      end

      it "moves to sake edit page" do
        expect(page).to have_current_path sake_path(sake_opened.id)
      end

      it "moves to sake edit page, and has success flash message" do
        expect(page).to have_css(".alert-success")
      end

      it "makes bottle empty" do
        expect do
          wait_for_page
          sake_opened.reload
        end.to change(sake_opened, :bottle_level).from("opened").to("empty")
      end
    end
  end
end
