require "rails_helper"

RSpec.describe "SakeShowSimpleLightboxes", type: :system do
  let(:sake) { sake_with_photos(photo_count: 1) }

  before do
    visit sake_path(sake.id)
  end

  context "when seeing photo preview" do
    before do
      find(:test_id, "sake_photo").click
    end

    it "has same path", js: true do
      expect(page).to have_current_path(sake_path(sake.id))
    end
  end
end
