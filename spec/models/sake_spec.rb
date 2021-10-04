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
#  emptied_at       :datetime
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
#  opened_at        :datetime
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
  let!(:sealed_sake) { FactoryBot.create(:sake, bottle_level: "sealed", size: 720) }
  let!(:opened_sake) { FactoryBot.create(:sake, bottle_level: "opened", size: 1800) }
  let!(:impressed_sake) { FactoryBot.create(:sake, bottle_level: "opened", aroma_value: 1, taste_value: 2, size: 1800) }
  let!(:empty_sake) { FactoryBot.create(:sake, bottle_level: "empty", size: 300) }

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

  describe "sake.sealed?" do
    it "returns true by sealed sake" do
      expect(sealed_sake.sealed?).to eq(true)
    end

    it "returns false by opened sake" do
      expect(opened_sake.sealed?).to eq(false)
    end

    it "returns false by empty sake" do
      expect(empty_sake.sealed?).to eq(false)
    end
  end

  describe "sake.opened?" do
    it "returns false by sealed sake" do
      expect(sealed_sake.opened?).to eq(false)
    end

    it "returns true by opened sake" do
      expect(opened_sake.opened?).to eq(true)
    end

    it "returns false by empty sake" do
      expect(empty_sake.opened?).to eq(false)
    end
  end

  describe "sake.unimpressed?" do
    it "returns true without taste and aroma value" do
      expect(opened_sake.unimpressed?).to eq(true)
    end

    it "returns false with taste and aroma value" do
      expect(impressed_sake.unimpressed?).to eq(false)
    end
  end

  describe "Sake.alcohol_stock" do
    context "without argument" do
      it "returns 2520" do
        # 720 + 1800/2 + 1800/2
        expect(described_class.alcohol_stock).to eq(2520)
      end
    end

    context "with include_empty: true" do
      it "returns 4320 including empty bottle" do
        # 720 + 1800 + 1800 + 300
        expect(described_class.alcohol_stock(include_empty: true)).to eq(4620)
      end
    end
  end
end
