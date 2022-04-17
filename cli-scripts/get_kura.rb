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
# @return [Array<Hash<Symbol => String>>] 地域とURLのハッシュ
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
# @return [Array<Hash<Symbol => String>>] 地域とURLのハッシュの配列
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
# @param kuras [Array<Hash<Symbol => String, Array<String>>>] 酒蔵のデータ
# @return [Array<Hash<Symbol => String, Array<String>>>] 追加済みの酒蔵のデータ
def add_kuras(kuras)
  kuras + [
    # 2020年に株式会社福井酒造場を合併し、2021年に酒造り開始
    { name: "井村屋株式会社", region: "三重県", meigaras: %w[福和蔵] },
    # 2021年に愛知県の森山酒造が移転合併した
    { name: "株式会社RiceWine", region: "神奈川", meigaras: %w[蜂龍盃] },
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
    in ["麓井酒造株式会社", "山形県"]
      meigaras + ["フモトヰ"]
    in ["天領酒造株式会社", "岐阜県"]
      meigaras + ["日野屋"]
    in ["株式会社平田酒造場", "岐阜県"]
      meigaras + %w[やまのひかり 山の光]
    in ["山﨑合資会社", "愛知県"]
      meigaras + ["尊王"]
    in ["丸一酒造株式会社", "愛知県"]
      meigaras + ["ほしいずみ"]
    in ["水谷酒造株式株式会社", "愛知県"]
      meigaras + %w[奏 めぐる]
    in ["渡辺酒造株式会社", "愛知県"]
      meigaras + ["平勇"]
    in ["中埜酒造株式会社", "愛知県"]
      meigaras + ["半田郷"]
    in ["盛田金しゃち酒造株式会社", "愛知県"]
      meigaras + ["初夢桜"]
    in ["原田酒造合資会社", "愛知県"]
      meigaras + %w[卯の花 於大の舞 衣が浦若水]
    else
      meigaras
    end
  meigaras.uniq
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize

# 銘柄に空白が含まれうるか
#
# @param region [String] 地域
# @return [Boolean] 銘柄に空白が含まれうるならtrue
def meigara_include_space?(region)
  %w[アフリカ オセアニア ヨーロッパ 中南米 北米].include?(region)
end

# SAKETIMESに載っている銘柄を複数に分解する
#
# SAKETIMESに載っている銘柄は以下の状態が含まれる。
# - 代表銘柄が載っておらず空文字
# - 代表銘柄が2つ以上あり、空白で区切られている
# - 代表銘柄自体に空白が含まれる
# そのため空白で区切っていい場合とだめな場合がある。
# 現状は海外地域でのみ銘柄に空白が含まれるため、これでHACKしている。
#
# @param meigaras [String] SAKETIMESに載っている代表銘柄
# @param region [String] 地域
# @return [Array<String>] 複数の代表銘柄に分解した代表銘柄
def split_meigara(meigaras, region)
  meigara_include_space?(region) && meigaras != "" ? [meigaras] : meigaras.split
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
# @return [Hash<Symbol => String, Array<String>>] 蔵名、地域、代表銘柄を持つハッシュ
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
# @return [Array<Hash<Symbol => String, Array<String>>>] 蔵名、地域、代表銘柄持ったハッシュの配列
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
# @param region_urls [Array<Hash<Symbol => String>>] 県名とURLのハッシュの配列
# @return [Array<Hash<Symbol => String, Array<String>>>] 蔵名、地域、代表銘柄持ったハッシュの配列
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
# @param jsons [Array<Hash<Symbol => String, Array<String>>] 蔵、地域、代表銘柄を持つjsonの配列
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
  write_ndjson(filename, kuras)

  puts("Done!")
  puts("Output to '#{filename}'")
end

main
