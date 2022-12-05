require "rails_helper"

RSpec.describe "Sake Index Order" do
  describe "sakes order in index" do
    let!(:sealed1) { create(:sake, name: "未開封のお酒1", bottle_level: "sealed") }
    let!(:opened1) { create(:sake, name: "開封済みのお酒1", bottle_level: "opened") }
    let!(:empty) { create(:sake, name: "空のお酒", bottle_level: "empty") }
    let!(:sealed2) { create(:sake, name: "未開封のお酒2", bottle_level: "sealed") }
    let!(:opened2) { create(:sake, name: "開封済みのお酒2", bottle_level: "opened") }

    before do
      visit sakes_path
    end

    context "if the 'show empty bottles' checkbox is not checked" do
      it "shows opened sakes before sealed sakes" do
        regexp = /#{sealed2.name}.*#{sealed1.name}.*#{opened2.name}.*#{opened1.name}/m
        expect(page.text).to match(regexp)
      end

      it "does not include empty sake" do
        regexp = /#{empty.name}}/
        expect(page.text).not_to match(regexp)
      end
    end

    context "if the 'show empty bottles' checkbox is checked", js: true do
      before do
        check("check_empty_bottle") # show empty bottles
      end

      it "shows sakes sorted by id" do
        regexp = /#{sealed2.name}.*#{sealed1.name}.*#{opened2.name}.*#{opened1.name}.*#{empty.name}/m
        expect(page.text).to match(regexp)
      end
    end
  end
end
