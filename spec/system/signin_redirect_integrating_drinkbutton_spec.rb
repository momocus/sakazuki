require "rails_helper"

RSpec.describe "Sign in redirect with drink buttons", type: :system do
  let!(:sealed_sake) { FactoryBot.create(:sake, bottle_level: "sealed") }
  let!(:impressed_sake) { FactoryBot.create(:sake, bottle_level: "opened", taste_value: 1, aroma_value: 2) }
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)
    sign_out(user)
    visit sakes_path
  end

  describe "impress button" do
    it "redirects edit page after sign in" do
      visit sakes_path
      id = sealed_sake.id
      click_link("open-and-impress-button-#{id}")
      signin_process_on_signin_page(user)
      # クエリ "?sake[bottle_level]=opened" 部を無視する
      expect(page).to have_current_path(edit_sake_path(id), ignore_query: true)
      sign_out(user)
    end
  end

  before do
    Capybara.current_driver = :selenium_headless
    sign_out(user)
    visit sakes_path
  end

  describe "open button of sealed sake" do
    it "redirects index page after sign in" do
      id = sealed_sake.id
      accept_confirm do
        click_link("open-button-#{id}")
      end
      wait_for_page
      signin_process_on_signin_page(user)
      expect(page).to have_current_path(sakes_path)
    end
  end

  describe "empty button" do
    it "redirects index page after sign in" do
      id = impressed_sake.id
      accept_confirm do
        click_link("empty-button-#{id}")
      end
      wait_for_page
      signin_process_on_signin_page(user)
      expect(page).to have_current_path(sakes_path)
    end
  end
end
