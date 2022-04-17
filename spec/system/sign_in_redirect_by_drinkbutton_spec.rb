require "rails_helper"

RSpec.describe "Sign-in Redirect by Drink Buttons" do
  let!(:sealed_sake) { create(:sake, bottle_level: "sealed") }
  let!(:impressed_sake) { create(:sake, bottle_level: "opened", taste_value: 1, aroma_value: 2) }
  let(:user) { create(:user) }

  before do
    sign_out(user)
    visit sakes_path
  end

  describe "impress button" do
    it "redirects edit page after sign in" do
      id = sealed_sake.id
      click_link("open-and-impress-button-#{id}")
      signin_process_on_signin_page(user)
      # クエリ "?sake[bottle_level]=opened" 部を無視する
      expect(page).to have_current_path(edit_sake_path(id), ignore_query: true)
    end
  end

  describe "open button of sealed sake" do
    it "redirects index page after sign in", js: true do
      id = sealed_sake.id
      accept_confirm do click_link("open-button-#{id}") end
      wait_for_page new_user_session_path
      signin_process_on_signin_page(user)
      expect(page).to have_current_path(sakes_path)
    end
  end

  describe "empty button" do
    it "redirects index page after sign in", js: true do
      id = impressed_sake.id
      accept_confirm do click_link("empty-button-#{id}") end
      wait_for_page new_user_session_path
      signin_process_on_signin_page(user)
      expect(page).to have_current_path(sakes_path)
    end
  end
end
