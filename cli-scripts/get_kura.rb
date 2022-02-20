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
  { region: region, url: url }
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

# 酒蔵の社名の変更を適用する
#
# @param name [String] 酒蔵名
# @return [String] 社名変更を適用した酒蔵名
def rename_kura(name)
  name.sub(/\(休業中\)/, "")
end

# SAKETIMESに載っていない酒蔵データを追加する
#
# @param datas [Array<Hash<Symbol => String>>] 酒蔵のデータ
# @return [Array<Hash<Symbol => String>>] 追加済みの酒蔵のデータ
def add_data!(datas)
  # 2020年に株式会社福井酒造場を合併し、2021年に酒造り開始
  datas.append({ kura: "井村屋株式会社", region: "三重県", meigaras: %w[福和蔵] })
  # 2021年に愛知県の森山酒造が移転合併した
  datas.append({ kura: "株式会社RiceWine", region: "神奈川", meigaras: %w[蜂龍盃] })
end

# SAKETIMESに載っていない代表銘柄を追加する
#
# 蔵名は重複があるため、地域も込みで判定を行う。
#
# @param kura [String] 蔵名
# @param region [String] 地域
# @param meigaras [Array<String>] SAKETIMESに載っている銘柄
# @return [Array<String>] 追加済み銘柄
def add_meigara(kura, region, meigaras)
  case [kura, region]
  in ["丸一酒造株式会社", "愛知県"]
    meigaras + ["ほしいずみ"]
  else
    meigaras
  end
end

# SAKETIMESの地域ページのテーブルカラムから、蔵データを作成する
#
# 帰ってくる代表銘柄は複数がありうるため、配列となっている。
#
# @param table_row [Nokogiri::XML::NodeSet] SAKETIMESのテーブルカラムのオブジェクト
# @param region [String] 地域
# @return [Hash<Symbol => String, Array<String>>] 蔵名、地域、代表銘柄を持つハッシュ
def tr_to_data(table_row, region)
  kura = table_row.css("span.main a")[0].content
  kura = rename_kura(kura)
  meigaras = table_row.css("dd")[0].content.split
  meigaras = add_meigara(kura, region, meigaras)
  { kura: kura, region: region, meigaras: meigaras }
end

# SAKETIMESの1つの地域から、蔵データを取得する
#
# @example 実行例
#   request_kuras([["北海道","https://jp.sake-times.com/sakagura/./hokkaido"]])
#     #=> [{ kura: "碓氷勝三郎商店", region: "北海道", meigaras: ["北の勝"]},
#         ...]
#
# @param url [String] SAKETIMESの地域の酒蔵ページのURL
# @param regoin [String] 地域名
# @return [Array<Hash<Symbol => String>>] 蔵名、地域、代表銘柄持ったハッシュの配列
def request_kuras(url, region)
  html = URI.parse(url).open
  trs = Nokogiri::HTML(html).css("table tr") # テーブルのrowであるtrをすべて取得
  return [] if trs.empty?                    # 地域に蔵がなければ終了

  trs = trs[1..]                # ヘッダを捨てる
  trs.reduce([]) { |accum, tr|
    datas = tr_to_data(tr, region)
    accum.append(datas)
  }
end

# SAKETIMESに掲載されているすべての蔵データを取得する
#
# @example 実行例
#   request_all_kuras([{region: "北海道",
#                       url: "https://jp.sake-times.com/sakagura/./hokkaido"},
#                       ...])
#     #=> [{ kura: "碓氷勝三郎商店", region: "北海道", meigaras: ["北の勝"]},
#          ...,
#          { kura: "YK3 Sake Producer Inc.", region: "北米", meigaras: ["悠(Yu)"]}]
#
# @param region_urls [Array<Hash<Symbol => String>>] 県名とURLのハッシュの配列
# @return [Array<Hash<Symbol => String>>] 蔵名、地域、代表銘柄持ったハッシュの配列
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
# @param names [Array<Hash<Symbol => String>] 県名と蔵名を持つjsonの配列
def write_ndjson(ndjson)
  filename = "kura-list.ndjson"
  File.open(filename, "wb") do |f|
    ndjson.each do |line_json|
      JSON.dump(line_json, f)
      f.write("\n")
    end
  end
end

def main
  regions = request_regions
  datas = request_all_kuras(regions)
  datas = add_data!(datas)
  write_ndjson(datas)
end

main
