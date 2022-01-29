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
#  emptied_at       :datetime         default(Fri, 01 Jan 2021 00:00:00.000000000 JST +09:00), not null
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
#  opened_at        :datetime         default(Fri, 01 Jan 2021 00:00:00.000000000 JST +09:00), not null
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

    context "if opened_at is nil" do
      let(:sake) { FactoryBot.build(:sake, opened_at: nil) }

      it { is_expected.to be_falsy }
    end

    context "if emptied_at is nil" do
      let(:sake) { FactoryBot.build(:sake, emptied_at: nil) }

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

  describe "Sake.new_arrival?" do
    before do
      # 2週間以内に購入した未開封の酒を、新着と判定する
      stub_const("#{described_class}::SEALD_NEW_LIMIT", 14.days)

      # 1週間以内に購入した開封済の酒を、新着と判定する
      stub_const("#{described_class}::OPENED_NEW_LIMIT", 7.days)
    end

    context "when sake is seald and created within 2 weeks" do
      it "returns true" do
        sealed_new_sake = FactoryBot.build(:sake, bottle_level: "sealed", created_at: Time.zone.today.ago(14.days))
        expect(sealed_new_sake.new_arrival?).to eq(true)
      end
    end

    context "when sake is seald and created more than 2 weeks ago" do
      it "returns false" do
        sealed_old_sake = FactoryBot.build(:sake, bottle_level: "sealed", created_at: Time.zone.today.ago(15.days))
        expect(sealed_old_sake.new_arrival?).to eq(false)
      end
    end

    context "when sake is opened and created within 1 week" do
      it "returns true" do
        opened_new_sake = FactoryBot.build(:sake, bottle_level: "opened", created_at: Time.zone.today.ago(7.days))
        expect(opened_new_sake.new_arrival?).to eq(true)
      end
    end

    context "when sake is opened and created more than 1 weeks ago" do
      it "returns false" do
        opened_old_sake = FactoryBot.build(:sake, bottle_level: "opened", created_at: Time.zone.today.ago(8.days))
        expect(opened_old_sake.new_arrival?).to eq(false)
      end
    end
  end
end
