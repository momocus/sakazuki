require "rails_helper"

RSpec.describe "Simple Lightboxes", :js do
  context "with sake show page" do
    before do
      visit sake_path(sake.id)
    end

    context "with avif photo" do
      let(:sake) { sake_with_photos }

      it "does not change current path" do
        find(:test_id, "sake_photo").click
        expect(page).to have_current_path(sake_path(sake.id))
      end
    end

    context "with jpg photo" do
      let(:sake) { sake_with_photos(file_ext: "jpg") }

      it "does not change current path" do
        find(:test_id, "sake_photo").click
        expect(page).to have_current_path(sake_path(sake.id))
      end
    end
  end
end
