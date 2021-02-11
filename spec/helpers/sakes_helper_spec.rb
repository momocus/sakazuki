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

  describe "start_year_limit" do
    it "must always return 30" do
      expect(start_year_limit).to eq(30)
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
end
