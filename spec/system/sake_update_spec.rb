require "rails_helper"

RSpec.describe "AfterUpdateAction", type: :system do
  let!(:opened_sake) { FactoryBot.create(:sake, bottle_level: "opened") }
  let(:sake_id) { opened_sake.id }
  let(:sake_name) { opened_sake.name }
  let(:user) { FactoryBot.create(:user) }

  describe "update from edit page" do
    before do
      sign_in(user)
      visit edit_sake_path(sake_id)
      find(:test_id, "form-submit").click
    end

    it "redirect to sake page" do
      expect(page).to have_current_path sake_path(sake_id)
    end

    it "has success flash message" do
      expect(page).to have_css(".alert-success")
    end

    it "has link to the updated sake" do
      expect(find(:test_id, "flash-message")).to have_link(sake_name, href: sake_path(sake_id))
    end
  end
end
