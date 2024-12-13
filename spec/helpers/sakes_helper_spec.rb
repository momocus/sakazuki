require "rails_helper"

RSpec.describe SakesHelper do
  include described_class

  describe "empty_to_default" do
    context "if first argument is presence" do
      value = 1
      default_value = 2

      it "returns first value" do
        expect(empty_to_default(value, default_value)).to eq(value)
      end
    end

    context "if first argument is nil" do
      nil_value = nil
      default_value = 2

      it "returns second value" do
        expect(empty_to_default(nil_value, default_value)).to eq(default_value)
      end
    end

    context "if first argument is empty string" do
      empty_string = ""
      default_value = 2

      it "returns second value" do
        expect(empty_to_default(empty_string, default_value)).to eq(default_value)
      end
    end
  end

  describe "to_by" do
    let(:date) { Date.current }

    it "always returns July" do
      expect(to_by(date).month).to eq(7)
    end

    it "always returns day 1" do
      expect(to_by(date).day).to eq(1)
    end

    context "if date is after 7/1" do
      let(:date) { Date.new(2021, 7, 1) }

      it "returns same year" do
        expect(to_by(date).year).to eq(date.year)
      end
    end

    context "if date is before 6/30" do
      let(:date) { Date.new(2021, 6, 30) }

      it "returns yeara ago" do
        expect(to_by(date).year).to eq(date.year - 1)
      end
    end
  end

  describe "by_collection" do
    it "generates a range ending with unknown" do
      candidate = [I18n.t("sakes.form_abstract.unknown"), ""]
      expect(by_collection.last).to eq(candidate)
    end

    it "generates a range having current year in second from last" do
      by = to_by(Time.current)
      candidate = [with_japanese_era(by), by.to_s]
      expect(by_collection[-2]).to eq(candidate)
    end

    it "generates a range starting with 30 years ago" do
      by = to_by(30.years.ago)
      candidate = [with_japanese_era(by), by.to_s]
      expect(by_collection.first).to eq(candidate)
    end
  end

  describe "bindume_collection" do
    it "generates a range ending with current" do
      date = Time.current.to_date.beginning_of_month
      year = with_japanese_era(date)
      month = I18n.l(date, format: "%B")
      candidate = ["#{year} #{month}", date.to_s]
      expect(bindume_collection.last).to eq(candidate)
    end

    it "generates a range starting with 30 years ago" do
      date = 30.years.ago.to_date.beginning_of_month
      year = with_japanese_era(date)
      month = I18n.l(date, format: "%B")
      candidate = ["#{year} #{month}", date.to_s]
      expect(bindume_collection.first).to eq(candidate)
    end
  end

  describe "with_japanese_era" do
    context "for normal year" do
      it "returns formated year including 令和" do
        expect(with_japanese_era(Date.new(2019, 5, 1))).to eq("2019 / 令和元年")
      end

      it "returns formated year including 平成" do
        expect(with_japanese_era(Date.new(2019, 4, 30))).to eq("2019 / 平成31年")
      end
    end
  end

  describe "to_shakkan" do
    it "returns value by Shakkan" do
      expect(to_shakkan(4500)).to eq("2升5合")
    end

    it "truncates and returns value" do
      expect(to_shakkan(300)).to eq("1合")
    end

    it "returns value without new unit over 10 Koku" do
      expect(to_shakkan(2_222_100)).to eq("12石3斗4升5合")
    end

    it "returns without the not beggiest zero" do
      expect(to_shakkan(18000)).to eq("1斗")
    end

    it "returns zero with Go" do
      expect(to_shakkan(0)).to eq("0合")
    end

    it "returns zero Go with argument less than 180" do
      expect(to_shakkan(100)).to eq("0合")
    end
  end

  describe "price_tag" do
    context "if the argument is nil" do
      it "returns text meaning market price" do
        expect(price_tag(nil)).to eq(t("sakes.menu.market_price"))
      end
    end

    context "if the argument is integer" do
      it "returns price tag with unit" do
        expect(price_tag(1234)).to eq("1234#{t('activerecord.attributes.sake.price_unit')}")
      end
    end
  end

  describe "title_with_search" do
    context "without search word" do
      it "returns only title" do
        title = I18n.t("sakes.index.title")
        expect(title_with_search(nil)).to eq(title)
      end
    end

    context "with search word" do
      it "returns title with search word" do
        searched = "生道井"
        title = "生道井 - #{I18n.t('sakes.index.title')}"
        expect(title_with_search(searched)).to eq(title)
      end
    end
  end

  describe "title_with_stock" do
    before do
      create(:sake, size: 720, bottle_level: "sealed")
      create(:sake, size: 1800, bottle_level: "empty")
    end

    it "returns title with 4合" do
      include_empty = false
      title = "#{I18n.t('.sakes.index.title')} - 4合"
      expect(title_with_stock(include_empty)).to eq(title)
    end

    it "returns title with 1升4合" do
      include_empty = true
      title = "#{I18n.t('.sakes.index.title')} - 1升4合"
      expect(title_with_stock(include_empty)).to eq(title)
    end
  end
end
