require "rails_helper"

RSpec.describe "Sake Form Bindume Date" do
  # SakesHelper.with_japanese_eraを使う
  include SakesHelper

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "year of bindume_on" do
    context "when visiting new sake page" do
      before do
        visit new_sake_path
      end

      it "selects this year" do
        year = with_japanese_era(Time.current)
        expect(page).to have_select("sake_bindume_on_1i", selected: year)
      end
    end

    context "when creating sake whoes bindume_on is this year" do
      before do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        year = with_japanese_era(Time.current)
        select(year, from: "sake_bindume_on_1i")
        click_button("form_submit")
      end

      it "has this year" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_on.year).to eq(Time.current.year)
      end
    end

    context "when creating sake whoes bindume_on is past year" do
      ago = Time.current.ago(10.years)

      before do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        year = with_japanese_era(ago)
        select(year, from: "sake_bindume_on_1i")
        click_button("form_submit")
      end

      it "has past year" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_on.year).to eq(ago.year)
      end
    end

    context "when visiting edit sake page" do
      let(:sake) { create(:sake, bindume_on: Date.parse("2021-07-01")) }

      before do
        visit edit_sake_path(sake.id)
      end

      it "selects the year of sake" do
        year = with_japanese_era(sake.bindume_on)
        expect(page).to have_select("sake_bindume_on_1i", selected: year)
      end
    end
  end

  describe "month of bindume_on" do
    context "when visiting new sake page" do
      before do
        visit new_sake_path
      end

      it "selected this month" do
        month = I18n.l(Time.current, format: "%b")
        expect(page).to have_select("sake_bindume_on_2i", selected: month)
      end
    end

    context "when creating sake whoes bindume_on is January" do
      before do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        month = I18n.l(Time.zone.parse("2022-01-01 10:30:00"), format: "%b")
        select(month, from: "sake_bindume_on_2i")
        click_button("form_submit")
      end

      it "has January" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_on.month).to eq(1)
      end
    end

    context "when creating sake whoes bindume_on is December" do
      before do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        month = I18n.l(Time.zone.parse("2022-12-01 10:30:00"), format: "%b")
        select(month, from: "sake_bindume_on_2i")
        click_button("form_submit")
      end

      it "has December" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_on.month).to eq(12)
      end
    end

    context "when visiting edit sake page" do
      let(:sake) { create(:sake, bindume_on: Date.parse("2021-07-01")) }

      before do
        visit edit_sake_path(sake.id)
      end

      it "selects the month of sake" do
        month = I18n.l(sake.bindume_on, format: "%b")
        expect(page).to have_select("sake_bindume_on_2i", selected: month)
      end
    end
  end
end
