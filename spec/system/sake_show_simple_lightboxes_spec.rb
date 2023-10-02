require "rails_helper"

RSpec.describe "Sake Show Simple Lightboxes", :js do
  let(:sake) { sake_with_photos(photo_count: 1) }

  before do
    visit sake_path(sake.id)
  end

  context "with avif photo" do
    let(:sake) { sake_with_photos }

    before do
      find(:test_id, "sake_photo").click
    end

    it "has same path" do
      expect(page).to have_current_path(sake_path(sake.id))
    end
  end

  context "with jpg photo" do
    let(:sake) { sake_with_photos(file_ext: "jpg") }

    before do
      find(:test_id, "sake_photo").click
    end

    it "has same path" do
      expect(page).to have_current_path(sake_path(sake.id))
    end
  end
end
