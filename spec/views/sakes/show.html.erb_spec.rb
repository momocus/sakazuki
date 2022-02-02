require "rails_helper"

# Capybaraを使うためにsystem specを指定する
RSpec.describe "sakes/show", type: :system do
  describe "dates" do
    let(:sake) { FactoryBot.create(:sake, bottle_level: :sealed) }

    some_date = %r{[0-9]+/[0-9]+/[0-9]+}

    context "with sealed sake" do
      before do
        visit sake_path(sake.id)
      end

      it "has created_at" do
        expect(find(:test_id, "created-at")).to have_text(some_date)
      end

      it "does not have opened_at" do
        expect(find(:test_id, "opened-at")).not_to have_text(some_date)
      end

      it "does not have emptied_at" do
        expect(find(:test_id, "emptied-at")).not_to have_text(some_date)
      end

      it "has updated_at" do
        expect(find(:test_id, "updated-at")).to have_text(some_date)
      end
    end

    context "with opened sake" do
      before do
        sake.update(bottle_level: "opened")
        visit sake_path(sake.id)
      end

      it "has created_at" do
        expect(find(:test_id, "created-at")).to have_text(some_date)
      end

      it "has opened_at" do
        expect(find(:test_id, "opened-at")).to have_text(some_date)
      end

      it "does not have emptied_at" do
        expect(find(:test_id, "emptied-at")).not_to have_text(some_date)
      end

      it "has updated_at" do
        expect(find(:test_id, "updated-at")).to have_text(some_date)
      end
    end

    context "with empty sake" do
      before do
        sake.update(bottle_level: "empty")
        visit sake_path(sake.id)
      end

      it "has created_at" do
        expect(find(:test_id, "created-at")).to have_text(some_date)
      end

      it "has opened_at" do
        expect(find(:test_id, "opened-at")).to have_text(some_date)
      end

      it "has emptied_at" do
        expect(find(:test_id, "emptied-at")).to have_text(some_date)
      end

      it "has updated_at" do
        expect(find(:test_id, "updated-at")).to have_text(some_date)
      end
    end
  end

  describe "rating" do
    let(:no_rating_sake) { FactoryBot.create(:sake) }
    let(:rating_sake) { FactoryBot.create(:sake, rating: 3) }

    context "with no rating sake" do
      before do
        visit sake_path(no_rating_sake.id)
      end

      it "has bar text" do
        expect(find(:test_id, "rating")).to have_text("-")
      end
    end

    context "with sake having 3 star rating" do
      before do
        visit sake_path(rating_sake.id)
      end

      it "has 3 stars-fill icons" do
        expect(page.all("i.bi-star-fill").count).to eq 3
      end

      it "has 2 stars icons, not filled" do
        expect(page.all("i.bi-star").count).to eq 2
      end
    end
  end
end
