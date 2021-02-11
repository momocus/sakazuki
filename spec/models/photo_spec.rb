# == Schema Information
#
# Table name: photos
#
#  id         :bigint           not null, primary key
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sake_id    :integer
#
require "rails_helper"

RSpec.describe Photo, type: :model do
  describe "chackbox_name" do
    let(:photo) { FactoryBot.create(:photo) }
    subject { photo.chackbox_name }
    it { is_expected.to eq "photo_delete_1" }
  end
end
