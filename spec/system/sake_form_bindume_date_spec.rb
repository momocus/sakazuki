require "rails_helper"

RSpec.describe "Sake Form Bindume Date", type: :system do
  # SakesHelper.with_japanese_eraを使う
  include SakesHelper

  let(:user) { create(:user) }

  before do
    sign_in user
    visit new_sake_path
    fill_in("sake_name", with: "生道井")
  end

  describe "year of bindume_date", js: true do
    context "when select current year" do
      before do
        year = with_japanese_era(Time.current)
        select(year, from: "sake_bindume_year")
        click_button("form_submit")
      end

      it "makes a sake whoes bindume year is current year" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_date.year).to eq(Time.current.year)
      end
    end

    context "when select 10 years ago" do
      ago = Time.current.ago(10.years)

      before do
        year = with_japanese_era(ago)
        select(year, from: "sake_bindume_year")
        click_button("form_submit")
      end

      it "makes a sake whoes bindume year is 10 years ago" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_date.year).to eq(ago.year)
      end
    end
  end

  describe "month of bindume_date", js: true do
    context "when select January" do
      before do
        month = I18n.l(Time.zone.parse("2022-01-01 10:30:00"), format: "%b")
        select(month, from: "sake_bindume_month")
        click_button("form_submit")
      end

      it "makes a sake whoes bindume month is January" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_date.month).to eq(1)
      end
    end

    context "when select December" do
      before do
        month = I18n.l(Time.zone.parse("2022-12-01 10:30:00"), format: "%b")
        select(month, from: "sake_bindume_month")
        click_button("form_submit")
      end

      it "makes a sake whoes bindume month is December" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_date.month).to eq(12)
      end
    end
  end
end
