require "rails_helper"

RSpec.describe "Sake Form Bindume Date", type: :system do
  # SakesHelper.with_japanese_eraを使う
  include SakesHelper

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "year of bindume_date" do
    context "when visiting new sake page" do
      before do
        visit new_sake_path
      end

      it "selects this year" do
        year = with_japanese_era(Time.current)
        expect(page).to have_select("sake_bindume_date_1i", selected: year)
      end
    end

    context "when creating new sake with current time" do
      before do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        year = with_japanese_era(Time.current)
        select(year, from: "sake_bindume_date_1i")
        click_button("form_submit")
      end

      it "has current year" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_date.year).to eq(Time.current.year)
      end
    end

    context "when creating new sake with past time" do
      ago = Time.current.ago(10.years)

      before do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        year = with_japanese_era(ago)
        select(year, from: "sake_bindume_date_1i")
        click_button("form_submit")
      end

      it "has past year" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_date.year).to eq(ago.year)
      end
    end

    context "when visiting edit sake page" do
      let(:sake) { create(:sake, bindume_date: Date.parse("2021-07-01")) }

      before do
        visit edit_sake_path(sake.id)
      end

      it "selects the year of sake" do
        year = with_japanese_era(sake.bindume_date)
        expect(page).to have_select("sake_bindume_date_1i", selected: year)
      end
    end
  end

  describe "month of bindume_date" do
    context "when visiting new sake page" do
      before do
        visit new_sake_path
      end

      it "selected this month" do
        month = I18n.l(Time.current, format: "%b")
        expect(page).to have_select("sake_bindume_date_2i", selected: month)
      end
    end

    context "when creating new sake with January" do
      before do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        month = I18n.l(Time.zone.parse("2022-01-01 10:30:00"), format: "%b")
        select(month, from: "sake_bindume_date_2i")
        click_button("form_submit")
      end

      it "has January" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_date.month).to eq(1)
      end
    end

    context "when creating new sake with December" do
      before do
        visit new_sake_path
        fill_in("sake_name", with: "生道井")
        month = I18n.l(Time.zone.parse("2022-12-01 10:30:00"), format: "%b")
        select(month, from: "sake_bindume_date_2i")
        click_button("form_submit")
      end

      it "has December" do
        sake = sake_from_show_path(page.current_path)
        expect(sake.bindume_date.month).to eq(12)
      end
    end

    context "when visiting edit sake page" do
      let(:sake) { create(:sake, bindume_date: Date.parse("2021-07-01")) }

      before do
        visit edit_sake_path(sake.id)
      end

      it "selects the month of sake" do
        month = I18n.l(sake.bindume_date, format: "%b")
        expect(page).to have_select("sake_bindume_date_2i", selected: month)
      end
    end
  end
end
