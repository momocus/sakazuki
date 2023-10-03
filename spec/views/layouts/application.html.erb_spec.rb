require "rails_helper"

# Capybaraを使うためにsystem specを指定する
RSpec.describe "layouts/application", type: :system do
  before do
    visit root_path
  end

  describe "letter_opener link" do
    it "is not in production and test environment" do
      expect(page).not_to have_selector(:css, 'a[href="/letter_opener"]')
    end
  end
end
