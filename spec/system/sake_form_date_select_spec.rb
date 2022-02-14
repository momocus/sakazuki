require "rails_helper"

RSpec.describe "Sake Form Date Select", type: :system do
  # HACK: sakes_helperのprivate methodであるwith_japanese_eraを使う
  include SakesHelper

  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  context "when new sake" do
    before do
      visit new_sake_path
    end

    describe "selector of bindume date" do
      it "selects this year" do
        year = with_japanese_era(Time.current)
        expect(page).to have_select("select_bindume_year", selected: year)
      end

      it "selects this month" do
        month = I18n.l(Time.current, format: "%b")
        expect(page).to have_select("select_bindume_month", selected: month)
      end
    end
  end

  context "when new sake before 7/1" do
    describe "selector of BY" do
      it "selects this BY" do
        datetime = Time.zone.parse("2022-06-30 20:30:00")
        travel_to(datetime)

        visit new_sake_path
        by = with_japanese_era(to_by(Time.current))
        expect(page).to have_select("select_by", selected: by)
      end
    end
  end

  context "when new sake after 7/1" do
    describe "selector of BY" do
      it "selects this BY" do
        datetime = Time.zone.parse("2022-07-1 10:30:00")
        travel_to(datetime)

        visit new_sake_path
        by = with_japanese_era(to_by(Time.current))
        expect(page).to have_select("select_by", selected: by)
      end
    end
  end

  context "when edit sake having bindume date and BY" do
    let(:sake) { FactoryBot.create(:sake, bindume_date: Date.new(2022, 2, 1), brew_year: Date.new(2021, 7, 1)) }

    before do
      visit edit_sake_path(sake.id)
    end

    describe "selector of bindume date" do
      it "selects the year of sake" do
        year = with_japanese_era(sake.bindume_date)
        expect(page).to have_select("select_bindume_year", selected: year)
      end

      it "selects the month of sake" do
        month = I18n.l(sake.bindume_date, format: "%b")
        expect(page).to have_select("select_bindume_month", selected: month)
      end
    end

    describe "selector of BY" do
      it "selects the BY of sake" do
        by = with_japanese_era(sake.brew_year)
        expect(page).to have_select("select_by", selected: by)
      end
    end
  end

  context "when edit sake not having BY" do
    let(:sake) { FactoryBot.create(:sake, brew_year: nil) }

    before do
      visit edit_sake_path(sake.id)
    end

    describe "selector of BY" do
      it "selects nil" do
        expect(page).to have_select("select_by", selected: I18n.t("sakes.form.unknown"))
      end
    end
  end
end
