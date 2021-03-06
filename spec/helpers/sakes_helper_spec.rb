require "rails_helper"

RSpec.describe SakesHelper, type: :helper do
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

  describe "year_range" do
    it "must generate a range starting from 30 years ago to the given year" do
      expect(year_range(2021).last).to eq(2021)
      expect(year_range(2021).first).to eq(1991)
      expect(year_range(2030).last).to eq(2030)
      expect(year_range(2030).first).to eq(2000)
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

  describe "bottom_bottle" do
    it "must always return -1" do
      expect(bottom_bottle).to eq(-1)
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
      expect(to_shakkan(100)).to eq ("0合")
    end
  end
end
