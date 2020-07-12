# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Sake.create!(
  name: "x", # string, 1 or more characters
  kura: "", # string
  photo: nil, # 未実装
  bindume_date: Date.new(2020, 6),
  brew_year: Date.new(2020),
  todofuken: "", # string
  taste_value: nil, # nil or integer 0 - 10
  aroma_value: nil, # nil or integer 0 - 10
  nihonshudo: nil, # nil or integer
  sando: nil, # nil or integer
  aroma_impression: "", # string
  color: "", # string
  taste_impression: "",
  nigori: "", # string
  awa: "", # string
  tokutei_meisho: :none,
  #   なし :none
  #   本醸造 :honjozo
  #   吟醸 :ginjo
  #   大吟醸 :daiginjo
  #   純米 :junmai
  #   純米吟醸 :junmai_ginjo
  #   純米大吟醸 :junmai_daiginjo
  #   特別本醸造 :tokubetsu_honjozo
  #   特別純米 :tokubetsu_junmai
  genryoumai: "", # string
  kakemai: "", # string
  kobo: "", # string
  alcohol: 15, # integer (nil禁止)
  aminosando: nil, # nil or integer
  season: "", # string
  warimizu: :unknown,
  #   不明 :unknown
  #   加水あり :kasui
  #   原酒（無加水） :genshu
  moto: :unknown,
  #   不明 :unknown
  #   生酛 :kimoto
  #   山廃 :yamahai
  #   速醸 :sokujo
  seimai_buai: nil, # nil or integer 0 - 10
  roka: "", # string (e.g. 無濾過, 素濾過, 不明)
  shibori: "", # string (e.g. 雫取り, 中組み, 不明)
  note: "", # string
  bottle_level: :sealed,
  #   未開栓 :sealed
  #   開封済 :opened
  #   空 :empty
  hiire: :unknown,
  #   不明 :unknown
  #   生生 :namanama
  #   前火入れ :mae_hiire
  #   あと火入れ :ato_hiire
  #   二度火入れ :nido_hiire
  price: nil,
  size: 0 # integer (nil禁止)
)
