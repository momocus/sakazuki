require "rails_helper"

# Capybaraを使うためにsystem specを指定する
RSpec.describe "sakes/index", type: :system do
  let!(:sake) { create(:sake) }

  describe "index page" do
    before do
      visit sakes_path
    end

    context "for a sake" do
      it "has edit link" do
        buttons = "sake_buttons_#{sake.id}"
        text = I18n.t("sakes.sake.edit")
        path = edit_sake_path(sake.id)
        expect(find(:test_id, buttons)).to have_link(text, href: path)
      end
    end
  end
end
