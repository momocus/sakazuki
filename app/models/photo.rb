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
class Photo < ApplicationRecord
  belongs_to :sake
  mount_uploader :image, ImageUploader

  def chackbox_name
    "photo_delete_#{id}"
  end
end
