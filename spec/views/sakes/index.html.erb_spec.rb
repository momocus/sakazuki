require "rails_helper"

# Capybaraを使うためにsystem specを指定する
RSpec.describe "sakes/index", type: :system do
  let!(:sake) { create(:sake, size: 720) }

  before do
    visit sakes_path
  end

  describe "sake" do
    it "has link to edit" do
      buttons = "sake_buttons_#{sake.id}"
      text = I18n.t("sakes.sake.edit")
      path = edit_sake_path(sake.id)
      expect(find(:test_id, buttons)).to have_link(text, href: path)
    end
  end

  describe "title" do
    it "has title with total amount of sake" do
      title = "#{I18n.t('sakes.index.title')} - 4合"
      expect(page).to have_text(title)
    end
  end

  describe "title meta tag" do
    context "when not searching" do
      it "has title" do
        title = "#{I18n.t('sakes.index.title')} - SAKAZUKI"
        expect(page).to have_title(title)
      end
    end

    context "when searching with some word" do
      before do
        fill_in("text_search", with: "検索中の酒")
        click_button("submit_search")
      end

      it "has title with searching words" do
        title = "検索中の酒 - #{I18n.t('sakes.index.title')} - SAKAZUKI"
        expect(page).to have_title(title)
      end
    end

    context "when searching with empty word" do
      before do
        fill_in("text_search", with: "")
        click_button("submit_search")
      end

      it "does not have title with searching words separator" do
        title = "- #{I18n.t('sakes.index.title')} - SAKAZUKI"
        expect(page).not_to have_title(title)
      end
    end
  end
end
