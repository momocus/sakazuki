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
#  bindume_date     :date
#  bottle_level     :integer          default("sealed")
#  brew_year        :date
#  color            :string
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
#  price            :integer
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
FactoryBot.define do
  factory :sake do
    name { "名前" }
    kura { "蔵" }
    todofuken { "都道府県" }
    aroma_impression { "香り" }
    color { "赤" }
    taste_impression { "味" }
    nigori { "にごり" }
    awa { "炭酸" }
    genryomai { "原料米" }
    kakemai { "掛米" }
    kobo { "酵母" }
    season { "新酒" }
    roka { "ろ過" }
    shibori { "絞り" }
    note { "note" }
    size { 100 }
  end
end
