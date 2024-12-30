require "rails_helper"

# Capybaraを使うためにsystem specを指定する
RSpec.describe "sakes/show", type: :system do
  describe "datetimes" do
    let(:sake) { create(:sake, bottle_level: :sealed) }

    context "with sealed sake" do
      before do
        visit sake_path(sake.id)
      end

      it "has created_at" do
        expect(find(:test_id, "created-at")).to have_text(I18n.l(sake.created_at.to_date))
      end

      it "does not have opened_at" do
        expect { find(:test_id, "opened-at") }.to raise_error(Capybara::ElementNotFound)
      end

      it "does not have emptied_at" do
        expect { find(:test_id, "emptied-at") }.to raise_error(Capybara::ElementNotFound)
      end
    end

    context "with opened sake" do
      before do
        sake.update!(bottle_level: "opened")
        visit sake_path(sake.id)
      end

      it "has created_at" do
        expect(find(:test_id, "created-at")).to have_text(I18n.l(sake.created_at.to_date))
      end

      it "has opened_at" do
        expect(find(:test_id, "opened-at")).to have_text(I18n.l(sake.opened_at.to_date))
      end

      it "does not have emptied_at" do
        expect { find(:test_id, "emptied-at") }.to raise_error(Capybara::ElementNotFound)
      end
    end

    context "with empty sake" do
      before do
        sake.update!(bottle_level: "empty")
        visit sake_path(sake.id)
      end

      it "has created_at" do
        expect(find(:test_id, "created-at")).to have_text(I18n.l(sake.created_at.to_date))
      end

      it "has opened_at" do
        expect(find(:test_id, "opened-at")).to have_text(I18n.l(sake.opened_at.to_date))
      end

      it "has emptied_at" do
        expect(find(:test_id, "emptied-at")).to have_text(I18n.l(sake.emptied_at.to_date))
      end
    end
  end

  describe "rating" do
    let(:no_rating_sake) { create(:sake) }
    let(:rating_sake) { create(:sake, rating: 3) }

    context "with no rating sake" do
      before do
        visit sake_path(no_rating_sake.id)
      end

      it "has 5 white stars icons" do
        expect(find(:test_id, "rating").all("i.bi-star.text-light").count).to eq(5)
      end

      it "has no colored star icon" do
        expect(find(:test_id, "rating").all("i.bi-star-fill").count).to eq(0)
      end
    end

    context "with sake having 3 star rating" do
      before do
        visit sake_path(rating_sake.id)
      end

      it "has 3 colored stars icons" do
        expect(find(:test_id, "rating").all("i.bi-star-fill.text-primary").count).to eq(3)
      end

      it "has 2 not colored stars icons" do
        expect(find(:test_id, "rating").all("i.bi-star-fill.text-light").count).to eq(2)
      end
    end
  end
end
