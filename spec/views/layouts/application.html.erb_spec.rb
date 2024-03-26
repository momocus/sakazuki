require "rails_helper"

# Capybaraを使うためにsystem specを指定する
RSpec.describe "layouts/application", type: :system do
  context "when production environment" do
    before do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
    end

    describe "letter_opener link" do
      before do
        visit root_path
      end

      it "does not exist" do
        expect(page).to have_no_xpath('//a[@href="/letter_opener"]')
      end
    end
  end
end
