require "rails_helper"

RSpec.describe "Sake Form Add Tax", :js do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    visit new_sake_path
  end

  context "when sake price is empty" do
    it "does nothing" do
      click_on("sake_add_tax")
      expect(find(:test_id, "sake_price").value).to eq ""
    end
  end

  context "when sake price is 1000" do
    before do
      fill_in("sake_price", with: 1000)
    end

    it "changes price to 1100" do
      click_on("sake_add_tax")
      expect(find(:test_id, "sake_price").value).to eq "1100"
    end
  end
end
