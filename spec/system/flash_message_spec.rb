require "rails_helper"

RSpec.describe "Flash Message" do
  let(:user) { create(:user) }
  let(:sake) { create(:sake) }

  context "without login" do
    # sake
    describe "asscess new sake page" do
      it "has flash message" do
        visit new_sake_path
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end

    describe "asscess edit sake page" do
      it "has flash message" do
        visit edit_sake_path(sake.id)
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end

    # invitation
    describe "asscess invitation page" do
      it "has flash message" do
        visit new_user_invitation_path
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end

    # devise
    describe "login" do
      it "has flash message" do
        visit sakes_path
        sign_in_via_header_button(user)
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end
  end

  context "with login" do
    before do
      sign_in(user)
    end

    # sake
    describe "create sake" do
      it "has flash message" do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        click_button("form_submit")
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end

    describe "update sake" do
      it "has flash message" do
        visit edit_sake_path(sake.id)
        fill_in("sake_name", with: "ほしいずみ")
        click_button("form_submit")
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end

    describe "delete sake", :js do
      it "has flash message" do
        visit sake_path(sake.id)
        accept_confirm do
          click_on("delete_sake")
        end
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end

    describe "copy sake" do
      it "has flash message" do
        visit sake_path(sake.id)
        click_link("copy_sake")
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end

    # devise
    describe "logout" do
      it "has flash message" do
        visit sakes_path
        click_link("sign_out")
        expect(page).to have_selector(:test_id, "flash_message")
      end
    end
  end
end
