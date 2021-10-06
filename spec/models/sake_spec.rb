# == Schema Information
#
# Table name: sakes
#
#  id               :bigint           not null, primary key
#  alcohol          :float
#  aminosando       :float
#  aroma_impression :text
#  aroma_value      :integer
#  awa              :string
#  bindume_date     :date
#  bottle_level     :integer          default("sealed")
#  brew_year        :date
#  color            :string
#  genryomai        :string
#  hiire            :integer          default("unknown")
#  kakemai          :string
#  kobo             :string
#  kura             :string
#  moto             :integer          default("unknown")
#  name             :string
#  nigori           :string
#  nihonshudo       :float
#  note             :text
#  price            :integer
#  roka             :string
#  sando            :float
#  season           :string
#  seimai_buai      :integer
#  shibori          :string
#  size             :integer
#  taste_impression :text
#  taste_value      :integer
#  todofuken        :string
#  tokutei_meisho   :integer          default("none")
#  warimizu         :integer          default("unknown")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "rails_helper"

RSpec.describe Sake do
  let!(:impressed_sake) { FactoryBot.create(:sake, bottle_level: "opened", aroma_value: 1, taste_value: 2, size: 1800) }
  let!(:opened_sake) { FactoryBot.create(:sake, bottle_level: "opened", size: 1800) }
  let!(:sealed_sake) { FactoryBot.create(:sake, bottle_level: "sealed", size: 720) }

  describe "validates" do
    subject { sake.save }

    context "if name is missing" do
      let(:sake) { FactoryBot.build(:sake, name: "") }

      it { is_expected.to be_falsy }
    end

    context "if kura is nil" do
      let(:sake) { FactoryBot.build(:sake, kura: nil) }

      it { is_expected.to be_falsy }
    end
  end

  describe "check sealed" do
    it "returns true" do
      expect(sealed_sake.sealed?).to be_truthy
    end

    it "returns false" do
      expect(opened_sake.sealed?).to be_falsy
    end
  end

  describe "check opened" do
    it "returns true" do
      expect(opened_sake.opened?).to be_truthy
    end

    it "returns false" do
      expect(sealed_sake.opened?).to be_falsy
    end
  end

  describe "check unimpressed" do
    it "returns true" do
      expect(opened_sake.unimpressed?).to be_truthy
    end

    it "returns false" do
      expect(impressed_sake.unimpressed?).to be_falsy
    end
  end

  describe "alcohol stock" do
    it "returns 2520" do
      expect(Sake.alcohol_stock).to eq(2520)
    end

    it "returns 4320 including empty bottle" do
      expect(Sake.alcohol_stock(include_empty: true)).to eq(4320)
    end
  end
end
