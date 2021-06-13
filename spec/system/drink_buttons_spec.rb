require "rails_helper"

RSpec.describe "DrinkButtons", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:sealed_sake) { FactoryBot.create(:sake, bottle_level: "sealed") }
  let!(:opened_sake) { FactoryBot.create(:sake, bottle_level: "opened") }
  let!(:impressed_sake) { FactoryBot.create(:sake, bottle_level: "opened", taste_value: 1, aroma_value: 2) }
  let!(:empty_sake) { FactoryBot.create(:sake, bottle_level: "empty", taste_value: 1, aroma_value: 2) }

  describe "sake column in index page" do
    before do
      visit sakes_path
    end

    open_text = I18n.t("sakes.index.open")
    impress_text = I18n.t("sakes.index.impress")
    empty_text = I18n.t("sakes.index.empty")

    describe "sealed bottle" do
      it "has open button with i18n text" do
        id = "bottle-level-#{sealed_sake.id}"
        expect(find(:test_id, id)).to have_text(open_text)
      end

      it "has impress button with i18n text" do
        id = "bottle-level-#{sealed_sake.id}"
        expect(find(:test_id, id)).to have_text(impress_text)
      end

      it "does not have empty button with i18n text" do
        id = "bottle-level-#{sealed_sake.id}"
        expect(find(:test_id, id)).to have_no_text(empty_text)
      end
    end

    describe "opened and unimpressed bottle" do
      it "does not have open button with i18n text" do
        id = "bottle-level-#{opened_sake.id}"
        expect(find(:test_id, id)).to have_no_text(open_text)
      end

      it "has impress button with i18n text" do
        id = "bottle-level-#{opened_sake.id}"
        expect(find(:test_id, id)).to have_text(impress_text)
      end

      it "has empty button with i18n text" do
        id = "bottle-level-#{opened_sake.id}"
        expect(find(:test_id, id)).to have_text(empty_text)
      end
    end

    describe "opened and impressed bottle" do
      it "does not have open button with i18n text" do
        id = "bottle-level-#{impressed_sake.id}"
        expect(find(:test_id, id)).to have_no_text(open_text)
      end

      it "does not have impress button with i18n text" do
        id = "bottle-level-#{impressed_sake.id}"
        expect(find(:test_id, id)).to have_no_text(impress_text)
      end

      it "has empty button with i18n text" do
        id = "bottle-level-#{impressed_sake.id}"
        expect(find(:test_id, id)).to have_text(empty_text)
      end
    end

    describe "empty bottle" do
      before do
        visit sakes_path
        page.check("check_empty_bottle")
        click_button("submit_search")
      end

      it "does not have open button with i18n text" do
        id = "bottle-level-#{empty_sake.id}"
        expect(find(:test_id, id)).to have_no_text(open_text)
      end

      it "does not have impress button with i18n text" do
        id = "bottle-level-#{empty_sake.id}"
        expect(find(:test_id, id)).to have_no_text(impress_text)
      end

      it "does not have empty button with i18n text" do
        id = "bottle-level-#{empty_sake.id}"
        expect(find(:test_id, id)).to have_no_text(empty_text)
      end
    end
  end

  context "without login" do
    before do
      visit sakes_path
    end

    describe "clicking open button in sealed bottle" do
      it "redirects to user login page" do
        id = "open-button-#{sealed_sake.id}"
        click_link id
        expect(page).to have_current_path new_user_session_path
      end
    end

    describe "clicking impress button in opened bottle" do
      it "redirects to user login page" do
        id = "impress-button-#{opened_sake.id}"
        click_link id
        expect(page).to have_current_path new_user_session_path
      end
    end

    describe "clicking empty button in impressed bottle" do
      it "redirects to user login page" do
        id = "empty-button-#{impressed_sake.id}"
        click_link id
        expect(page).to have_current_path new_user_session_path
      end
    end
  end

  context "with login" do
    before do
      user = FactoryBot.create(:user)
      sign_in(user)
      visit sakes_path
    end

    describe "clicking impress button of sealed bottle" do
      before do
        id = "open-and-impress-button-#{sealed_sake.id}"
        click_link id
      end

      it "redirects to sake edit page" do
        path = edit_sake_path(sealed_sake.id)
        # クエリ "?sake[bottle_level]=opened" 部を無視する
        expect(page).to have_current_path(path, ignore_query: true)
      end

      it "moves to edit page and has 'opened' state" do
        id = "sake_bottle_level"
        text = I18n.t("enums.sake.bottle_level.opened")
        expect(page).to have_select(id: id, selected: text)
      end
    end

    describe "clicking open button of sealed bottle" do
      it "updates sake to opened" do
        expect {
          click_link "open-button-#{sealed_sake.id}"
          wait_for_page
          sealed_sake.reload
        }.to change(sealed_sake, :bottle_level).from("sealed").to("opened")
      end
    end

    describe "clicking impress button of opened bottle" do
      before do
        id = "impress-button-#{opened_sake.id}"
        click_link id
      end

      it "redirects to sake edit page" do
        path = edit_sake_path(opened_sake)
        expect(page).to have_current_path path
      end

      it "moves to edit page and keep 'opened' state" do
        id = "sake_bottle_level"
        text = I18n.t("enums.sake.bottle_level.opened")
        expect(page).to have_select(id: id, selected: text)
      end
    end
  end

  context "with login by selenium driver" do
    before do
      Capybara.current_driver = :selenium_headless
      user = FactoryBot.create(:user)
      sign_in(user)
      visit sakes_path
    end

    describe "clicking empty button of impressed bottle" do
      before do
        accept_confirm do
          click_link "empty-button-#{impressed_sake.id}"
        end
      end

      it "moves to sake show page" do
        expect(page).to have_current_path sake_path(impressed_sake.id)
      end

      it "has success flash message" do
        expect(page).to have_css(".alert-success")
      end

      it "updates sake to empty" do
        expect {
          wait_for_page
          impressed_sake.reload
        }.to change(impressed_sake, :bottle_level).from("opened").to("empty")
      end
    end
  end
end
