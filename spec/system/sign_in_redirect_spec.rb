require "rails_helper"

RSpec.describe "Sign-in redirect", type: :system do
  let(:sakes) { FactoryBot.create_list(:sake, 3) }
  let(:id) { sakes[0].id }
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)
    sign_out(user)
  end

  context "when not signed user tries to edit sake" do
    before do
      visit sake_path(id)
      find(:test_id, "edit-#{id}").click
    end

    it "redirects to sign in page" do
      expect(page).to have_current_path new_user_session_path
    end

    it "redirect to sake editing page after sign in" do
      signin_process_on_signin_page(user)
      expect(page).to have_current_path edit_sake_path(id)
    end
  end

  context "when not signed user tries to create sake" do
    before do
      visit sakes_path
      find(:test_id, "new-sake").click
    end

    it "redirects to sign in page" do
      expect(page).to have_current_path new_user_session_path
    end

    it "redirects to sake creation page after sign in" do
      signin_process_on_signin_page(user)
      expect(page).to have_current_path new_sake_path
    end
  end

  context "when user signs in from header button on sake show page" do
    before do
      visit sake_path(id)
      sign_in_via_header_button(user)
    end

    it "redirects to sake show page" do
      expect(page).to have_current_path sake_path(id)
    end
  end

  context "when user signs in from header button on sign in page" do
    before do
      visit new_user_session_path
      sign_in_via_header_button(user)
    end

    it "redirects to root url (does not occur redirection loop)" do
      expect(page).to have_current_path root_path
    end
  end
end
