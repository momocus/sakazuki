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
#  emptied_at       :datetime         default(Fri, 01 Jan 2021 00:00:00.000000000 JST +09:00), not null
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
#  opened_at        :datetime         default(Fri, 01 Jan 2021 00:00:00.000000000 JST +09:00), not null
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
    name { "生道井" }
    kura { "" }
    todofuken { "" }
    size { 720 }
    genryomai { "" }
    kakemai { "" }
    kobo { "" }
    season { "" }
    roka { "" }
    shibori { "" }
    color { "" }
    nigori { "" }
    aroma_impression { "" }
    taste_impression { "" }
    awa { "" }
    note { "" }
    opened_at { Time.current }
    emptied_at { Time.current }
  end
end
