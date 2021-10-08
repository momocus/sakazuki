require "rails_helper"

RSpec.describe "Edit Sake" do
  let!(:sake) { FactoryBot.create(:sake) }
  let(:sake_id) { sake.id }
  let(:sake_name) { sake.name }
  let(:user) { FactoryBot.create(:user) }

  describe "update from edit page" do
    before do
      sign_in(user)
      visit edit_sake_path(sake_id)
      click_button("form-submit")
    end

    it "redirect to sake page" do
      expect(page).to have_current_path sake_path(sake_id)
    end

    it "has success flash message" do
      text = I18n.t("sakes.update.success", name: sake_name)
      expect(find(:test_id, "flash-message")).to have_text(text)
    end

    it "has link to the updated sake" do
      expect(find(:test_id, "flash-message")).to have_link(sake_name, href: sake_path(sake_id))
    end
  end
end
