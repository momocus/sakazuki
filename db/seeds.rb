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

# See ./../app/models/sake.rb
Sake.create!(
  alcohol: 15.0,
  aminosando: nil,
  name: "純米吟醸 別仕込 萩の鶴 ねこラベル",
  kura: "萩野酒造株式会社",
  photos: [],
  bindume_date: Date.new(2020, 6),
  brew_year: Date.new(2019, 7),
  todofuken: "宮城県",
  taste_value: 3,
  aroma_value: 5,
  nihonshudo: nil,
  sando: nil,
  aroma_impression: "",
  color: "",
  taste_impression: "",
  nigori: "",
  awa: "",
  tokutei_meisho: :junmai_ginjo,
  genryomai: "美山錦",
  kakemai: "",
  kobo: "",
  season: "",
  warimizu: :unknown,
  moto: :unknown,
  seimai_buai: 50,
  roka: "",
  shibori: "",
  note: "",
  bottle_level: :empty,
  hiire: :namanama,
  price: 3080,
  size: 1800,
)

Sake.create!(
  name: "千瓢原酒",
  kura: "水谷酒造",
  photos: [],
  bindume_date: Date.new(2019, 12),
  brew_year: Date.new(2019, 7),
  todofuken: "愛知県",
  nihonshudo: nil,
  sando: nil,
  aroma_impression: "",
  color: "",
  taste_impression: "",
  nigori: "",
  awa: "",
  tokutei_meisho: :none,
  genryomai: "",
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
  bottle_level: :empty,
  hiire: :namanama,
  price: nil,
  size: 1800,
)

Sake.create!(
  name: "黄金澤 山廃純米酒 うすにごり原酒",
  kura: "合名会社 川敬商店",
  photos: [],
  bottle_level: :empty,
  bindume_date: Date.new(2020, 6),
  brew_year: Date.new(2019, 7),
  todofuken: "宮城県",
  alcohol: 16.0,
  size: 1800,
  tokutei_meisho: :junmai,
  warimizu: :genshu,
  moto: :yamahai,
  nigori: "うすにごり",
  hiire: :unknown,
  seimai_buai: 60,
  nihonshudo: nil,
  sando: nil,
  aroma_impression: "",
  color: "",
  taste_impression: "",
  awa: "",
  genryomai: "",
  kakemai: "",
  kobo: "",
  aminosando: nil,
  season: "",
  roka: "",
  shibori: "",
  note: "",
  price: 2807,
)

Sake.create!(
  name: "微濾過 吟醸 越後蔵元仕込み",
  kura: "加茂錦酒造",
  photos: [],
  bottle_level: :empty,
  bindume_date: Date.new(2020, 4),
  brew_year: Date.new(2019, 7),
  todofuken: "新潟県",
  alcohol: 15.0,
  size: 720,
  tokutei_meisho: :ginjo,
  warimizu: :unknown,
  moto: :unknown,
  nigori: "",
  hiire: :namanama,
  seimai_buai: 60,
  nihonshudo: nil,
  sando: nil,
  aroma_impression: "",
  color: "",
  taste_impression: "",
  awa: "",
  genryomai: "",
  kakemai: "",
  kobo: "",
  aminosando: nil,
  season: "",
  roka: "微濾過",
  shibori: "",
  note: "",
  price: nil,
)

# 笹井酒造

Sake.create!(
  alcohol: 16.0,
  aminosando: nil,
  aroma_impression: "酸や複雑な旨味の香り",
  aroma_value: 4,
  awa: "",
  bindume_date: Date.new(2020, 8),
  bottle_level: :opened,
  brew_year: Date.new(2019),
  color: "無色",
  genryomai: "ひとごこち",
  hiire: :namanama,
  kakemai: "ひとごこち",
  kobo: "長野酵母",
  kura: "笹井酒造株式会社",
  moto: :yamahai,
  name: "笹の誉 純米吟醸山廃仕込み 生 ひとごこち",
  nigori: "",
  nihonshudo: nil,
  note: "鶏肉に合わせてうまい！",
  photos: [],
  price: 3410,
  roka: "",
  sando: nil,
  season: "",
  seimai_buai: 55,
  shibori: "",
  size: 1800,
  taste_impression: "味はクリアな甘さにドドドドっと旨味がしっかり乗る。豆のような甘さ。山廃にしてはあんまや酸っぽくない味。最後は舌に苦味を残して、クドすぎない潔くほどよいキレ。",
  taste_value: 3,
  todofuken: "長野",
  tokutei_meisho: :junmai_ginjo,
  warimizu: :kasui,
)

Sake.create!(
  alcohol: 17.0,
  aminosando: nil,
  aroma_impression: "木や薫香を感じる",
  aroma_value: 2,
  awa: "",
  bindume_date: Date.new(2020, 8),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "黄色",
  genryomai: "ひとごこち",
  hiire: :namanama,
  kakemai: "ひとごこち",
  kobo: "協会901号酵母",
  kura: "笹井酒造株式会社",
  moto: :unknown,
  name: "笹の誉 特別純米酒 直汲み生 ひとごこち",
  nigori: "",
  nihonshudo: -2,
  note: "",
  photos: [],
  price: nil,
  roka: "",
  sando: nil,
  season: "",
  seimai_buai: 55,
  shibori: "",
  size: 720,
  taste_impression: "ヒネ、旨味、苦味がドンとくる。ちょっと味わいが強いお酒だけど、奥にある酸がほどよい余韻で終わらせる。生と古酒が一緒にくる、すごい。",
  taste_value: 5,
  todofuken: "長野",
  tokutei_meisho: :junmai,
  warimizu: :kasui,
)

# EH酒造

Sake.create!(
  alcohol: 15.0,
  aminosando: nil,
  aroma_impression: "ほのかにキレイなアルコール感ある香り",
  aroma_value: 1,
  awa: "",
  bindume_date: Date.new(2020, 8),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "無色",
  genryomai: "",
  hiire: :ato_hiire,
  kakemai: "",
  kobo: "",
  kura: "EH酒造株式会社",
  moto: :unknown,
  name: "信濃の国 酔園 生酒 純米吟醸",
  nigori: "",
  nihonshudo: nil,
  note: "まったりおいしい",
  photos: [],
  price: nil,
  roka: "",
  sando: nil,
  season: "",
  seimai_buai: 59,
  shibori: "",
  size: 720,
  taste_impression: "クリア感から始まり、苦味旨味が口の奥で広がる、奥行きある味わい。大人しめの生貯らしい味。苦味の余韻も長め。",
  taste_value: 4,
  todofuken: "長野",
  tokutei_meisho: :junmai_ginjo,
  warimizu: :kasui,
)

# 善哉酒造

Sake.create!(
  alcohol: 19.0,
  aminosando: nil,
  aroma_impression: "ややヒネの弱い香り",
  aroma_value: 3,
  awa: "",
  bindume_date: Date.new(2020, 8),
  bottle_level: :opened,
  brew_year: Date.new(2019),
  color: "薄い黄色",
  genryomai: "美山錦",
  hiire: :nido_hiire,
  kakemai: "美山錦",
  kobo: "",
  kura: "善哉酒造株式会社",
  moto: :unknown,
  name: "女鳥羽の泉 吟醸辛口 無濾過原酒",
  nigori: "",
  nihonshudo: nil,
  note: "",
  photos: [],
  price: nil,
  roka: "無濾過",
  sando: nil,
  season: "",
  seimai_buai: 59,
  shibori: "",
  size: 720,
  taste_impression: "味はふたコブラクダ。先にくるのは吟醸らしく淡く儚い甘さ。あとからググッとあがるアルコール感がきて、名前の通りのキレの良さを出してる。飲み続けるとふたコブが一緒になって、よりしんみりした味わい。",
  taste_value: 1,
  todofuken: "長野",
  tokutei_meisho: :ginjo,
  warimizu: :genshu,
)

Sake.create!(
  alcohol: 18.0,
  aminosando: nil,
  aroma_impression: "弱いアルコールとヒネ感と旨さ",
  aroma_value: 1,
  awa: "",
  bindume_date: Date.new(2020, 8),
  bottle_level: :opened,
  brew_year: Date.new(2019),
  color: "薄い黄色",
  genryomai: "",
  hiire: :ato_hiire,
  kakemai: "",
  kobo: "",
  kura: "善哉酒造株式会社",
  moto: :unknown,
  name: "女鳥羽の泉 夏純米 生貯蔵原酒",
  nigori: "",
  nihonshudo: nil,
  note: "暑い日に氷を浮かべてより爽やかにも楽しめる。",
  photos: [],
  price: nil,
  roka: "",
  sando: nil,
  season: "",
  seimai_buai: 65,
  shibori: "",
  size: 720,
  taste_impression: "味は濃さを感じる旨味がグリグリくる。めちゃ濃いのに嫌な感じがせず、なぜかキレもよく爽やかに終わる。",
  taste_value: 4,
  todofuken: "長野",
  tokutei_meisho: :ginjo,
  warimizu: :genshu,
)

Sake.create!(
  alcohol: 16.0,
  aminosando: nil,
  aroma_impression: "弱い軽さあるりんご系",
  aroma_value: 1,
  awa: "",
  bindume_date: Date.new(2020, 8),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "ほぼ無色",
  genryomai: "兵庫県産山田錦（１等米以上）",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "平孝酒造株式会社",
  moto: :unknown,
  name: "純米秋あがり 日高見",
  nigori: "",
  nihonshudo: 2,
  note: "魚にはやっぱり日高見だっちゃ！",
  photos: [],
  price: 1540,
  roka: "",
  sando: nil,
  season: "ひやおろし",
  seimai_buai: 60,
  shibori: "",
  size: 720,
  taste_impression: "ロックのように軽やかな味わい。香りや酸で甘酸っぱさも少しあるけど、旨み中心の味。特にあとから旨味や苦味ががふわっと盛り上がるのが素敵。",
  taste_value: 2,
  todofuken: "宮城",
  tokutei_meisho: :junmai,
  warimizu: :kasui,
)

Sake.create!(
  alcohol: 16.0,
  aminosando: nil,
  aroma_impression: "バナナ系の華やかな香り",
  aroma_value: 4,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "やや黄色",
  genryomai: "",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "合名会社川敬商店",
  moto: :yamahai,
  name: "山廃 純米原酒 黄金澤 ひやおろし",
  nigori: "",
  nihonshudo: nil,
  note: "食事がすすむすすむ。",
  photos: [],
  price: 1404,
  roka: "",
  sando: nil,
  season: "ひやおろし",
  seimai_buai: 60,
  shibori: "",
  size: 720,
  taste_impression: "口に入れると酸や複雑さがあり、急に山廃だと思い出される。しっかりした味だけど、落ち着きがあり嫌さがない綺麗さ。酸でキレもよい。",
  taste_value: 4,
  todofuken: "宮城",
  tokutei_meisho: :junmai,
  warimizu: :genshu,
)

Sake.create!(
  alcohol: 15.0,
  aminosando: nil,
  aroma_impression: "弱くスッキリした香り",
  aroma_value: 1,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "うっすら黄色",
  genryomai: "",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "阿部勘酒造株式会社",
  moto: :unknown,
  name: "純米吟醸 阿部勘 さざんか",
  nigori: "",
  nihonshudo: 3,
  note: "",
  photos: [],
  price: 1650,
  roka: "",
  sando: nil,
  season: "ひやおろし",
  seimai_buai: 55,
  shibori: "",
  size: 720,
  taste_impression: "口当たりは透明感ある淡く上品な旨さ。と思うと、舌の奥で舌にくる炭酸感や苦味が盛り上がってくるのがよい。キレイと旨さの山のかわりが最高。",
  taste_value: 2,
  todofuken: "宮城",
  tokutei_meisho: :junmaiginjo,
  warimizu: :kasui,
)

Sake.create!(
  alcohol: 16.0,
  aminosando: nil,
  aroma_impression: "強くないけどバニラやキャラメルのような芳醇さを感じる香り",
  aroma_value: 2,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "無色",
  genryomai: "蔵の華",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "株式会社一ノ蔵",
  moto: :unknown,
  name: "特別純米酒 ひやおろし 一ノ蔵",
  nigori: "",
  nihonshudo: 1,
  note: "夜長を感じる。",
  photos: [],
  price: 1500,
  roka: "",
  sando: nil,
  season: "ひやおろし",
  seimai_buai: 55,
  shibori: "",
  size: 720,
  taste_impression: "柑橘やベリーのような濃厚な旨味が膨らむ。しっかりしているが落ち着いた秋らしい旨さ。ほどよく舌にピリッとくる余韻もある。",
  taste_value: 4,
  todofuken: "宮城",
  tokutei_meisho: :tokubetsu_junmai,
  warimizu: :kasui,
)

Sake.create!(
  alcohol: 16.0,
  aminosando: nil,
  aroma_impression: "酸もあるスッキリした林檎系の香り",
  aroma_value: 3,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "瓶で黄色いけどコップではやや黄色",
  genryomai: "",
  hiire: :unknown,
  kakemai: "",
  kobo: "",
  kura: "萩野酒造株式会社",
  moto: :unknown,
  name: "萩の鶴 メガネ専用 全員メガネの蔵人で造りました 特別純米酒",
  nigori: "",
  nihonshudo: -2,
  note: "",
  photos: [],
  price: 3190,
  roka: "",
  sando: nil,
  season: "",
  seimai_buai: 60,
  shibori: "",
  size: 1800,
  taste_impression: "メガネ専用 全員メガネの蔵人で造りました 特別純米酒。瓶で黄色いけどコップではやや黄色。"\
                    "酸もあるスッキリした林檎系の香り。"\
                    "味もジューシーなりんごのような甘さをベースに、アルコールの辛さと旨さが少々ずつ。"\
                    "味は広がりがありゆっくり去っていく。山はきつくなく優しい。",
  taste_value: 4,
  todofuken: "宮城",
  tokutei_meisho: :tokubetsu_junmai,
  warimizu: :kasui,
)

Sake.create!(
  alcohol: 15.0,
  aminosando: nil,
  aroma_impression: "香りは弱く淡い",
  aroma_value: 0,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "ほぼ無色",
  genryomai: "ひだほまれ",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "天領酒造株式会社",
  moto: :unknown,
  name: "日野屋 純米吟醸酒 飛騨産ひだほまれ60% 秋あがり",
  nigori: "",
  nihonshudo: 4,
  note: "もう一口と飲みたくなる美味さ。",
  photos: [],
  price: nil,
  roka: "",
  sando: nil,
  season: "秋あがり",
  seimai_buai: 60,
  shibori: "",
  size: 720,
  taste_impression: "味は旨口系で、旨味にほどよいバランスのヒネや酸味がある。どっしり系の味わいなのに強すぎず、柔らかさを感じられる。",
  taste_value: 5,
  todofuken: "岐阜",
  tokutei_meisho: :junmai_ginjo,
  warimizu: :kasui,
)

Sake.create!(
  alcohol: 16.0,
  aminosando: nil,
  aroma_impression: "弱く、うっすらアルコール",
  aroma_value: 1,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "少し黄色",
  genryomai: "雄町",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "株式会社男山本店",
  moto: :unknown,
  name: "美禄＜秋＞ 純米吟醸 ひやおろし 秋月の露しずく",
  nigori: "",
  nihonshudo: 1,
  note: "しんみりと飲み続けられる美味さ",
  photos: [],
  price: 1834,
  roka: "",
  sando: nil,
  season: "ひやおろし",
  seimai_buai: 55,
  shibori: "",
  size: 720,
  taste_impression: "口の中で膨らむ優しい旨さが飽満。あと渋味系の味が舌をキュっと締める。さすがの落ち着き、味の山は低いけど長い。",
  taste_value: 3,
  todofuken: "宮城",
  tokutei_meisho: :junmai_ginjo,
  warimizu: :kasui,
)

Sake.create!(
  alcohol: 17.0,
  aminosando: nil,
  aroma_impression: "弱く儚い",
  aroma_value: 1,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "けっこう黄色",
  genryomai: "美山錦",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "宮城酵母",
  kura: "金の井酒造株式会社",
  moto: :unknown,
  name: "特別純米酒 美山錦 川口納豆 ひやおろし",
  nigori: "",
  nihonshudo: 5,
  note: "",
  photos: [],
  price: 3300,
  roka: "",
  sando: 1.9,
  season: "ひやおろし",
  seimai_buai: 55,
  shibori: "",
  size: 1800,
  taste_impression: "秋酒だけど最初っからぱっと開くお酒。開くのはアルコール感が強く、ふくよかな旨味や少しガス感もともに膨らむ。けっこうしっかりした味が膨らむのに、不思議と飲み終わったあとは爽やか。",
  taste_value: 4,
  todofuken: "宮城",
  tokutei_meisho: :tokubetsu_junmai,
  warimizu: :kasui,
)

Sake.create!(
  alcohol: 17.0,
  aminosando: nil,
  aroma_impression: "さっぱりと上品な弱いメロンの香り",
  aroma_value: 2,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "わずかに黄色",
  genryomai: "山田錦",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "有限会社大沼酒造",
  moto: :unknown,
  name: "ひやおろし 乾坤一純米吟醸やまだにしき大沼屋醸",
  nigori: "",
  nihonshudo: nil,
  note: "ひやおろしを覆された美味さ。",
  photos: [],
  price: 1760,
  roka: "",
  sando: nil,
  season: "ひやおろし",
  seimai_buai: 50,
  shibori: "",
  size: 720,
  taste_impression: "香りに対して、びっくりするほどぱっと甘酸っぱいフルーティさはじける！旨みも確かに乗ってるけど、やはり表の甘酸っぱさが強い。",
  taste_value: 4,
  todofuken: "宮城",
  tokutei_meisho: :junmai_ginjo,
  warimizu: :genshu,
)

Sake.create!(
  alcohol: 16.0,
  aminosando: nil,
  aroma_impression: "乳酸の旨味を感じる",
  aroma_value: 3,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "やや黄色",
  genryomai: "美山錦",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "蔵王酒造株式会社",
  moto: :unknown,
  name: "ZAO 特別純米 原酒K 秋あがり",
  nigori: "",
  nihonshudo: 3,
  note: "ラベルもかわいい。",
  photos: [],
  price: 2915,
  roka: "",
  sando: nil,
  season: "ひやおろし",
  seimai_buai: 55,
  shibori: "",
  size: 1800,
  taste_impression: "口に入れるとフレッシュなバナナのような旨さが広がる。舌に優しく触れるソフトな当たり。味の盛り上がりは強すぎず優しい。と思いきや、後味はアルコールや苦味が強めの余韻。",
  taste_value: 5,
  todofuken: "宮城",
  tokutei_meisho: :tokubetsu_junmai,
  warimizu: :genshu,
)

Sake.create!(
  alcohol: 16.0,
  aminosando: nil,
  aroma_impression: "弱く、旨味をうっすら感じる。",
  aroma_value: 1,
  awa: "",
  bindume_date: Date.new(2020, 9),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "少し黄色",
  genryomai: "ひだほまれ",
  hiire: nil,
  kakemai: "",
  kobo: "",
  kura: "天領酒造株式会社",
  moto: :unknown,
  name: "二年熟成 純米吟醸原酒",
  nigori: "",
  nihonshudo: 3,
  note: "しんみりと飲み続けられる美味さ",
  photos: [],
  price: nil,
  roka: "",
  sando: nil,
  season: "",
  seimai_buai: 60,
  shibori: "",
  size: 720,
  taste_impression: "柔らかな舌触りから、ほどよい酸と旨味の調和がとれた上品な味。山が優しくすーとあがり、しんみりと余韻長く去っていく。出来がよいしとてもおいしく、飲み飽きない。",
  taste_value: 3,
  todofuken: "岐阜",
  tokutei_meisho: :junmai_ginjo,
  warimizu: :genshu,
)

Sake.create!(
  alcohol: 17.0,
  aminosando: nil,
  aroma_impression: "芳醇な甘さが乗ったアルコール",
  aroma_value: 4,
  awa: "",
  bindume_date: Date.new(2020, 8),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "無色",
  genryomai: "ひだほまれ",
  hiire: :namanama,
  kakemai: "",
  kobo: "",
  kura: "奥飛騨酒造株式会社",
  moto: :unknown,
  name: "無濾過 生原酒 純米吟醸 生酒 奥飛騨",
  nigori: "",
  nihonshudo: nil,
  note: "",
  photos: [],
  price: 1628,
  roka: "無濾過",
  sando: nil,
  season: "",
  seimai_buai: 60,
  shibori: "",
  size: 720,
  taste_impression: "無濾過らしい生酒のフレッシュさが花開くうまさ。濃厚な日本酒の旨さと痺れるアルコール感と、トゲトゲしいが、舌にとろりと絡み、それが強く強く美味い。",
  taste_value: 5,
  todofuken: "岐阜",
  tokutei_meisho: :junmai_ginjo,
  warimizu: :genshu,
)

Sake.create!(
  alcohol: 17.0,
  aminosando: nil,
  aroma_impression: "完熟メロンのような香り",
  aroma_value: 4,
  awa: "",
  bindume_date: Date.new(2020, 8),
  bottle_level: :empty,
  brew_year: Date.new(2019),
  color: "うっすら黄色",
  genryomai: "",
  hiire: :mae_hiire,
  kakemai: "",
  kobo: "",
  kura: "金虎酒造株式会社",
  moto: :unknown,
  name: "金虎 純米 ひやおろし",
  nigori: "",
  nihonshudo: nil,
  note: "秋刀魚焼きや赤から鍋の強い味にも合う。",
  photos: [],
  price: 1320,
  roka: "",
  sando: nil,
  season: "ひやおろし",
  seimai_buai: 60,
  shibori: "",
  size: 720,
  taste_impression: "口ですぐに完熟な甘さと強い旨さがくる。そこをアルコールと苦さによる辛さが舌を強くしっかり洗い流す。味はガッツリしてるがキレもよい。",
  taste_value: 5,
  todofuken: "愛知",
  tokutei_meisho: :junmai,
  warimizu: :unknown,
)
