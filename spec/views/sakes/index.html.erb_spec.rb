require "rails_helper"

# Capybaraを使うためにsystem specを指定する
RSpec.describe "sakes/index", type: :system do
  let(:user) { create(:user) }
  let!(:sake) { create(:sake) }

  describe "index page" do
    before do
      sign_in(user)
      visit sakes_path
    end

    it "has edit button" do
      id = "sakes-index-edit-link"
      text = I18n.t("sakes.index.edit")
      expect(find(:test_id, id)).to have_text(text)
    end

    it "moves to sake edit page" do
      id = "sakes-index-edit-link"
      path = edit_sake_path(sake.id)
      click_link(id)
      expect(page).to have_current_path(path, ignore_query: true)
    end
  end
end
