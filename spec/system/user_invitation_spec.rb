require "rails_helper"

RSpec.describe "User invitation", type: :system do
  let!(:admin) { FactoryBot.create(:user, admin: true) }
  let!(:bartender) { FactoryBot.create(:user, admin: false) }

  before do
    sign_out(admin)
    sign_out(bartender)
  end

  context "when someone accesses to invitation url" do
    describe "admin" do
      before do
        sign_in(admin)
        visit new_user_invitation_path
      end
      it "can visit user invitation page" do
        expect(page).to have_current_path new_user_invitation_path
      end
    end
    describe "bartender" do
      before do
        sign_in(bartender)
        visit new_user_invitation_path
      end

      it "is redirected to index page" do
        expect(page).to have_current_path root_path
      end
    end
    describe "not signed in user" do
      before do
        visit new_user_invitation_path
      end
      it "is redirected to sign in page" do
        expect(page).to have_current_path new_user_session_path
      end
    end
  end
end
