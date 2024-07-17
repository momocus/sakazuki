#!/usr/bin/env ruby

# SakeTimesの酒蔵一覧を使ってNDJSONを作るスクリプト
#
# NDJSONには1行に1データが入っており改行で区切られている。
# 内容は
#  {name: String(酒蔵名）, region: String(都道府県名)}
# となっている。
#
# このデータを利用するには以下のように、1行ずつJSON.parseをすればよい。
#   File.foreach(filename, chomp: true) do |line|
#     json =  JSON.parse(line)
#     p json
#   end
#
# SakeTimesのウェブページは各都道府県（海外含む）ごとに別ページになっている。
# そこで、まずは都道府県の一覧を取得してから、実際の酒蔵の名前を取得する
#
#   https://jp.sake-times.com/sakagura" 都道府県一覧のページ
#      |
#      +-- /hokkaido 北海道の酒蔵一覧
#      +-- /aomori   青森県の酒蔵一覧
#      ...

require "open-uri"
require "nokogiri"
require "json"

# aタグオブジェクトから地域とURLのハッシュを作る
#
# @param a_tag [Nokogiri::XML::Element] Nokogiriで生成したHTMLのaタグオブジェクト
# @return [Array<Hash{Symbol => String}>] 地域とURLのハッシュ
def a_to_region(a_tag)
  url = a_tag.attributes["href"].value
  # "北海道（13）"のようになっているので、括弧と数字を削る
  region = a_tag.content.sub(/\uff08.*\uff09/, "")
  { region:, url: }
end

# SakeTimesの酒蔵一覧ページから、地域とURLのハッシュを作る
#
# 地域は都道府県と海外広域（ex. アジア）がある。
#
# @example 実行例
#   request_regions
#     #=> [{ region: "北海道",
#            url: "https://jp.sake-times.com/sakagura/./hokkaido"] },
#          ...]
#
# @return [Array<Hash{Symbol => String}>] 地域とURLのハッシュの配列
def request_regions
  base_url = "https://jp.sake-times.com/sakagura/"
  html = URI.parse(base_url).open
  doc = Nokogiri::HTML(html).css("ul.sakayagura-list li a")
  doc.map { |a| a_to_region(a) }
end

# 酒蔵の社名の変更など修正を適用する
#
# 休業中や末尾全角スペースの削除をする。
#
# @param name [String] 酒蔵名
# @return [String] 修正した酒蔵名
def rename(name)
  name.sub(/\(休業中\)/, "").sub(/　+$/, "")
end

# SAKETIMESに載っていない酒蔵データを追加する
#
# @param kuras [Array<Hash{Symbol => String, Array<String>}>] 酒蔵のデータ
# @return [Array<Hash{Symbol => String, Array<String>}>] 追加済みの酒蔵のデータ
def add_kuras(kuras)
  kuras + [
    # 2020年に株式会社福井酒造場を合併し、2021年に酒造り開始
    { name: "井村屋株式会社", region: "三重県", meigaras: ["福和蔵"] },
    # 2021年に愛知県の森山酒造が神奈川県に移転し、㈱RiceWineの委託醸造をしている
    { name: "森山酒造場", region: "神奈川", meigaras: %w[蜂龍盃 HINEMOS] },
    # 一度やめたが2022年より再開した
    { name: "伊東株式会社", region: "愛知", meigaras: ["敷嶋"] },
  ]
end

# SAKETIMESに載っていない代表銘柄を追加する
#
# 蔵名は重複があるため、地域も込みで判定を行う。
#
# @param name [String] 蔵名
# @param region [String] 地域
# @param meigaras [Array<String>] SAKETIMESに載っている銘柄
# @return [Array<String>] 追加済み銘柄
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
def add_meigara(name, region, meigaras)
  meigaras =
    case [name, region]
    in ["勝山酒造株式会社", "宮城県"]
      meigaras + ["戦勝政宗"]
    in ["大和蔵酒造株式会社", "宮城県"]
      meigaras + ["大和蔵"]
    in ["有限会社佐々木酒造店", "宮城県"]
      meigaras + ["浪の音"]
    in ["阿部勘酒造株式会社", "宮城県"]
      meigaras + %w[於茂多加 四季の松島 塩竈門前]
    in ["株式会社一ノ蔵", "宮城県"]
      meigaras + %w[大和伝 すず音 ひめぜん 金龍]
    in ["株式会社新澤醸造店", "宮城県"]
      meigaras + ["愛宕の松"]
    in ["株式会社田中酒造店", "宮城県"]
      meigaras + ["田林"]
    in ["株式会社山和酒造店", "宮城県"]
      meigaras + ["わしが國"]
    in ["合名会社川敬商店", "宮城県"]
      meigaras + ["橘屋"]
    in ["合名会社寒梅酒造", "宮城県"]
      meigaras + ["鶯咲"]
    in ["株式会社中勇酒造店", "宮城県"]
      meigaras + ["花ノ文"]
    in ["千田酒造株式会社", "宮城県"]
      meigaras + ["奥鶴"]
    in ["萩野酒造株式会社", "宮城県"]
      meigaras + ["日輪田"]
    in ["株式会社角星", "宮城県"]
      meigaras + %w[金紋両國 船尾灯]
    in ["株式会社男山本店", "宮城県"]
      meigaras + %w[気仙沼男山 美禄]
    in ["墨廼江酒造株式会社", "宮城県"]
      meigaras + %w[谷風 弁慶岬]
    in ["蔵王酒造株式会社", "宮城県"]
      meigaras + ["ZAO"]
    in ["森民酒造本家", "宮城県"]
      meigaras + ["森民"]
    in ["株式会社山本酒造店", "秋田県"]
      meigaras + ["白瀑"]
    in ["麓井酒造株式会社", "山形県"]
      meigaras + ["フモトヰ"]
    in ["東の麓酒造有限会社", "山形県"]
      meigaras + ["天弓"]
    in ["合名会社大谷忠吉本店", "福島県"]
      meigaras + ["登龍"]
    in ["宮泉銘醸株式会社", "福島県"]
      meigaras + ["宮泉"]
    in ["有賀醸造合資会社", "福島県"]
      meigaras + %w[生粋左馬 陣屋]
    in ["株式会社虎屋本店", "栃木県"]
      meigaras + ["菊"]
    in ["大矢孝酒造株式会社", "神奈川県"]
      meigaras + ["残草蓬莱"]
    in ["株式会社一本義久保本店", "福井県"]
      meigaras + ["伝心"]
    in ["七笑酒造株式会社", "長野県"]
      meigaras + ["七笑"]
    in ["天領酒造株式会社", "岐阜県"]
      meigaras + ["日野屋"]
    in ["株式会社平田酒造場", "岐阜県"]
      meigaras + %w[やまのひかり 山の光]
    in ["山﨑合資会社", "愛知県"]
      meigaras + ["尊王"]
    in ["丸一酒造株式会社", "愛知県"]
      meigaras + ["ほしいずみ"]
    in ["水谷酒造株式会社", "愛知県"]
      meigaras + %w[奏 めぐる]
    in ["渡辺酒造株式会社", "愛知県"]
      meigaras + ["平勇"]
    in ["中埜酒造株式会社", "愛知県"]
      meigaras + ["半田郷"]
    in ["盛田金しゃち酒造株式会社", "愛知県"]
      meigaras + ["初夢桜"]
    in ["原田酒造合資会社", "愛知県"]
      meigaras + %w[卯の花 於大の舞 衣が浦若水]
    in ["中野BC株式会社", "和歌山県"]
      meigaras + ["兆久"]
    in ["文本酒造株式会社", "高知県"]
      meigaras + %w[四万十 霧の里]
    else
      meigaras
    end
  meigaras.uniq
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity

# SAKETIMESの海外の地域かどうか
#
# @param region [String] 地域
# @return [Boolean] 地域が海外ならtrue
def oversea?(region)
  %w[アフリカ オセアニア ヨーロッパ 中南米 北米].include?(region)
end

# 複数の区切り文字で順番に銘柄の分解を試みる
#
# 区切り文字は配列で複数を受け取り、先頭から順番に分解を試す。
# 文字2個以上に分解できたら、即その区切り文字を採用する。
#
# @param meigaras [String] SAKETIMESに載っている代表銘柄
# @param seps [Array<String>] 区切り文字の配列
# @return [Array<String>] 複数の代表銘柄に分解した代表銘柄
def try_split(meigaras, seps)
  return [meigaras] if seps.empty?

  split_meigaras = meigaras.split(seps.first)
  if split_meigaras.length > 1  # split成功したか
    split_meigaras
  else
    try_split(meigaras, seps.drop(1))
  end
end

# SAKETIMESに載っている銘柄を複数に分解する
#
# SAKETIMESに載っている銘柄は以下の状態が含まれる。
# - 代表銘柄が載っておらず空文字
# - 代表銘柄が2つ以上あり、下記のいずれかの方法で区切られている
#   - 空白
#     - 茨城県 株式会社笹目宗兵衛商店 「二波山 松緑」
#     - 千葉県 青柳酒造株式会社 「金紋 篠緑」
#   - 読点（、）
#     - 兵庫県 八鹿酒造有限会社 「吉野、夫婦杉」
#   - 中点（・）
#     - 山口県 村重酒造株式会社 「金冠黒松・村重・eight knot」
#   - 空白とスラッシュ（ / ）
#     - 千葉県 鍋店株式会社 「仁勇 / 不動」
#   - 銘柄が「」で囲まれている
#     - 長野県 和饗酒造株式会社 『「和饗」「わきょう」』
# - 代表銘柄自体に空白が含まれる（海外の蔵たちと山口県の村重酒造のeight knot）
# そのため、複数の区切り文字でsplitを試す。
#
# 海外地域の銘柄は空白が含まれる、かつ、銘柄0種か1種のため、特別処理で対応している。
# 長野県の桝一市村酒造場の「スクウェア・ワン」は特別処理する。
#
# @param meigaras [String] SAKETIMESに載っている代表銘柄
# @param region [String] 地域
# @return [Array<String>] 複数の代表銘柄に分解した代表銘柄
def split_meigara(meigaras, region)
  meigaras.strip!               # 先頭・末尾の空白は取り除いておく

  return [] if meigaras == ""
  return [meigaras] if oversea?(region)
  return [meigaras] if meigaras == "スクウェア・ワン"
  # HACK: 和饗は諦めて特別処理する
  return meigaras.delete("「").split("」") if region == "長野県" && meigaras == "「和饗」「わきょう」"

  try_split(meigaras, [" / ", "、", "・", " "])
end

# SAKETIMESの地域ページのテーブルカラムから、蔵名を作成する
#
# @param table_row [Nokogiri::XML::NodeSet] SAKETIMESのテーブルカラムのオブジェクト
# @return [String] 蔵名
def tr_to_name(table_row)
  name = table_row.css("span.main a")[0].content
  rename(name)
end

# SAKETIMESの地域ページのテーブルカラムから、代表銘柄を作成する
#
# @param table_row [Nokogiri::XML::NodeSet] SAKETIMESのテーブルカラムのオブジェクト
# @param region [String] 地域
# @return [Array<String>>] 代表銘柄
def tr_to_meigaras(table_row, region)
  meigaras_str = table_row.css("dd")[0].content
  split_meigara(meigaras_str, region)
end

# SAKETIMESの地域ページのテーブルカラムから、蔵データを作成する
#
# 帰ってくる代表銘柄は複数がありうるため、配列となっている。
#
# @param table_row [Nokogiri::XML::NodeSet] SAKETIMESのテーブルカラムのオブジェクト
# @param region [String] 地域
# @return [Hash{Symbol => String, Array<String>}] 蔵名、地域、代表銘柄を持つハッシュ
def tr_to_kura(table_row, region)
  name = tr_to_name(table_row)
  meigaras = tr_to_meigaras(table_row, region)
  meigaras = add_meigara(name, region, meigaras)
  { name:, region:, meigaras: }
end

# SAKETIMESの1つの地域から、蔵データを取得する
#
# @example 実行例
#   request_kuras([["北海道","https://jp.sake-times.com/sakagura/./hokkaido"]])
#     #=> [{ name: "碓氷勝三郎商店", region: "北海道", meigaras: ["北の勝"]},
#         ...]
#
# @param url [String] SAKETIMESの地域の酒蔵ページのURL
# @param region [String] 地域名
# @return [Array<Hash{Symbol => String, Array<String>}>] 蔵名、地域、代表銘柄持ったハッシュの配列
def request_kuras(url, region)
  html = URI.parse(url).open
  trs = Nokogiri::HTML(html).css("table tr") # テーブルのrowであるtrをすべて取得
  return [] if trs.empty?                    # 地域に蔵がなければ終了

  trs = trs[1..]                # ヘッダを捨てる
  trs.map { |tr| tr_to_kura(tr, region) }
end

# SAKETIMESに掲載されているすべての蔵データを取得する
#
# @example 実行例
#   request_all_kuras([{region: "北海道",
#                       url: "https://jp.sake-times.com/sakagura/./hokkaido"},
#                       ...])
#     #=> [{ name: "碓氷勝三郎商店", region: "北海道", meigaras: ["北の勝"]},
#          ...,
#          { name: "YK3 Sake Producer Inc.", region: "北米", meigaras: ["悠(Yu)"]}]
#
# @param region_urls [Array<Hash{Symbol => String}>] 県名とURLのハッシュの配列
# @return [Array<Hash{Symbol => String, Array<String>}>] 蔵名、地域、代表銘柄持ったハッシュの配列
def request_all_kuras(region_urls)
  region_urls.map { |r_u|
    case r_u
    in { region: region, url: url }
      request_kuras(url, region)
    else
      raise(ArgumentError)
    end
  }.flatten(1)
end

# ファイルにNDJSON形式で保存する
#
# @param filename [String] 出力ファイル名
# @param jsons [Array<Hash{Symbol => String, Array<String>}>] 蔵、地域、代表銘柄を持つjsonの配列
def write_ndjson(filename, jsons)
  File.open(filename, "wb") do |f|
    jsons.each do |json|
      JSON.dump(json, f)
      f.write("\n")
    end
  end
end

def main
  regions = request_regions
  kuras = request_all_kuras(regions)
  kuras = add_kuras(kuras)

  filename = "kura-list.ndjson"
  path = "#{__dir__}/#{filename}"
  write_ndjson(path, kuras)

  puts("Done!")
  puts("Output to '#{filename}'")
end

main
