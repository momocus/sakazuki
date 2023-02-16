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
#  bindume_on       :date
#  bottle_level     :integer          default("sealed")
#  brewery_year     :date
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
#  rating           :integer          default(0), not null
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
  let!(:sealed_sake) { create(:sake, bottle_level: "sealed", size: 720) }
  let!(:opened_sake) { create(:sake, bottle_level: "opened", size: 1800) }
  let!(:impressed_sake) { create(:sake, bottle_level: "opened", aroma_value: 1, taste_value: 2, size: 1800) }
  let!(:empty_sake) { create(:sake, bottle_level: "empty", size: 300) }

  describe "validates" do
    subject { sake.save }

    context "if name is missing" do
      let(:sake) { build(:sake, name: "") }

      it { is_expected.to be_falsy }
    end

    context "if kura is nil" do
      let(:sake) { build(:sake, kura: nil) }

      it { is_expected.to be_falsy }
    end

    context "if opened_at is nil" do
      let(:sake) { build(:sake, opened_at: nil) }

      it { is_expected.to be_falsy }
    end

    context "if emptied_at is nil" do
      let(:sake) { build(:sake, emptied_at: nil) }

      it { is_expected.to be_falsy }
    end
  end

  describe "sake.sealed?" do
    it "returns true by sealed sake" do
      expect(sealed_sake.sealed?).to be(true)
    end

    it "returns false by opened sake" do
      expect(opened_sake.sealed?).to be(false)
    end

    it "returns false by empty sake" do
      expect(empty_sake.sealed?).to be(false)
    end
  end

  describe "sake.opened?" do
    it "returns false by sealed sake" do
      expect(sealed_sake.opened?).to be(false)
    end

    it "returns true by opened sake" do
      expect(opened_sake.opened?).to be(true)
    end

    it "returns false by empty sake" do
      expect(empty_sake.opened?).to be(false)
    end
  end

  describe "sake.unimpressed?" do
    it "returns true without taste and aroma value" do
      expect(opened_sake.unimpressed?).to be(true)
    end

    it "returns false with taste and aroma value" do
      expect(impressed_sake.unimpressed?).to be(false)
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
      travel_to(Time.zone.parse("2022-01-30 20:30:00"))
    end

    context "when sake is seald and created within 4 weeks" do
      let(:sake) { create(:sake, bottle_level: "sealed", created_at: Time.zone.parse("2022-01-02 10:30:00")) }

      it "returns true" do
        expect(sake.new_arrival?).to be(true)
      end
    end

    context "when sake is seald and created more than 4 weeks ago" do
      let(:sake) { create(:sake, bottle_level: "sealed", created_at: Time.zone.parse("2022-01-01 10:30:00")) }

      it "returns false" do
        expect(sake.new_arrival?).to be(false)
      end
    end

    context "when sake is opened and created within 2 week" do
      let(:sake) { create(:sake, bottle_level: "opened", created_at: Time.zone.parse("2022-01-16 10:30:00")) }

      it "returns true" do
        expect(sake.new_arrival?).to be(true)
      end
    end

    context "when sake is opened and created more than 2 weeks ago" do
      let(:sake) { create(:sake, bottle_level: "opened", created_at: Time.zone.parse("2022-01-15 10:30:00")) }

      it "returns false" do
        expect(sake.new_arrival?).to be(false)
      end
    end
  end

  describe "Sake.selling_price" do
    context "if price is nil" do
      let(:sake) { build(:sake, price: nil, size: 100) }

      it "returns nil" do
        expect(sake.selling_price).to be_nil
      end
    end

    context "if price is zero" do
      let(:sake) { build(:sake, price: nil, size: 0) }

      it "returns nil" do
        expect(sake.selling_price).to be_nil
      end
    end

    context "if size is nil" do
      let(:sake) { build(:sake, price: 100, size: nil) }

      it "returns nil" do
        expect(sake.selling_price).to be_nil
      end
    end

    context "if size is zero" do
      let(:sake) { build(:sake, price: 100, size: 0) }

      it "returns nil" do
        expect(sake.selling_price).to be_nil
      end
    end

    context "if price is 1,234 yen per 720 ml and selling rate is 3" do
      let(:sake) { build(:sake, price: 1234, size: 720) }

      before do
        stub_const("#{described_class}::SELLING_RATE", 3)
      end

      it "returns 1000" do
        expect(sake.selling_price).to eq(1000)
      end
    end

    context "if price is 1,234 yen per 720 ml and selling rate is 1.5" do
      let(:sake) { build(:sake, price: 1234, size: 720) }

      before do
        stub_const("#{described_class}::SELLING_RATE", 1.5)
      end

      it "returns 500" do
        expect(sake.selling_price).to eq(500)
      end
    end
  end
end
