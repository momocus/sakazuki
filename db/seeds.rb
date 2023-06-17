# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' },
#                          { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  email: "example@example.com",
  password: "rootroot",
  admin: true,
  # HACK: confirmed_atカラムに値が入っていれば、deviseが認証済みと判断する
  confirmed_at: Time.current
)

Sake.create!(
  name: "純米吟醸 別仕込 萩の鶴 ねこラベル",
  kura: "萩野酒造株式会社",
  photos: [],
  bindume_date: Date.new(2020, 6),
  brew_year: Date.new(2019, 7),
  todofuken: "宮城県",
  taste_value: 7,
  aroma_value: 8,
  nihonshudo: nil,
  sando: nil,
  aroma_impression: "",
  color: "",
  taste_impression: "",
  nigori: "",
  awa: "",
  tokutei_meisho: :junmai_ginjo,
  genryoumai: "美山錦",
  kakemai: "",
  kobo: "",
  alcohol: 15.0,
  aminosando: nil,
  season: "",
  warimizu: :unknown,
  moto: :unknown,
  seimai_buai: 50,
  roka: "",
  shibori: "",
  note: "",
  bottle_level: :opened,
  hiire: :namanama,
  price: 3080,
  size: 1800,
)

Sake.create!(
  name: "千瓢原酒",
  kura: "水谷酒造",
  photos: [],
  bindume_date: Date.new(2019, 12),
  brew_year: Date.new(2019,7),
  todofuken: "愛知県",
  nihonshudo: nil,
  sando: nil,
  aroma_impression: "",
  color: "",
  taste_impression: "",
  nigori: "",
  awa: "",
  tokutei_meisho: :none,
  genryoumai: "",
  kakemai: "",
  kobo: "",
  alcohol: 21,
  aminosando: nil,
  season: "",
  warimizu: :genshu,
  moto: :unknown,
  seimai_buai: nil,
  roka: "",
  shibori: "",
  note: "",
  bottle_level: :opened,
  hiire: :namanama,
  price: nil,
  size: 1800,
)
