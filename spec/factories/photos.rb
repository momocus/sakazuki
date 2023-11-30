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
FactoryBot.define do
  factory :photo do
    id { 1 }
    image { "temp_path" }
    sake
  end
end
