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

RSpec.describe Photo do
  describe "chackbox_name" do
    subject { photo.chackbox_name }

    let(:photo) { create(:photo) }

    it { is_expected.to eq "photo_delete_1" }
  end
end
