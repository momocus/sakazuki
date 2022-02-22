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

# SakeTimesの酒蔵一覧ページから、都道府県名とURLの組を作る
#
# @example 実行例
#   request_regions #=> [["北海道", "https://jp.sake-times.com/sakagura/./hokkaido"], ...]
#
# @return [Array<Array<String>>] 県名とURLの組の配列
def request_regions
  base_url = "https://jp.sake-times.com/sakagura/"
  html = URI.parse(base_url).open
  doc = Nokogiri::HTML(html).css("ul.sakayagura-list li a")
  doc.map { |a|
    url = a.attributes["href"].value
    # "北海道（13）"のようになっているので、括弧と数字を削る
    region = a.content.gsub(/\uff08.*\uff09/, "")
    [region, url]
  }
end

# 酒蔵の社名の変更を適用する
#
# @param name [String] 酒蔵名
# @return [String] 社名変更を適用した酒蔵名
def rename_sakagura(name)
  name.sub(/\(休業中\)/, "")
end

def add_sakagura(names)
  # 2020年に株式会社福井酒造場を合併し、2021年に酒造り開始
  names.append(%w[三重県 井村屋株式会社])
  # 2021年に愛知県の森山酒造が移転合併した
  names.append(%w[神奈川 株式会社RiceWine])
end

# SakeTimesの都道府県の酒蔵一覧ページから、都道府県名と酒蔵の名前の組を作る
#
# @example 実行例
#   request_names([["北海道","https://jp.sake-times.com/sakagura/./hokkaido"]])
#     #=> [["北海道", "碓氷勝三郎商店"],
#          ["北海道", "男山株式会社"], ...]
#
# @param regions [Array<Array<String>>] 県名とURLの組の配列
# @return [Array<Array<String>>] 県名と蔵名の組の配列
def request_names(regions)
  regions.map { |region, url|
    html = URI.parse(url).open
    doc = Nokogiri::HTML(html).css("table span.main a")
    names = doc.map { |table|
      rename_sakagura(table.content)
    }
    [region].product(names)
  }.flatten(1)
end

# 県名と蔵名一覧をNDJSON形式にする
#
# @example 実行例
#   to_ndjson([["北海道", "碓氷勝三郎商店"]]) #=> [{name:"碓氷勝三郎商店", region:"北海道"}]
#
# @param names [Array<Array<String>>] 県名と蔵名の組の配列
# @return [Array<Hash<Symbol => String>] 蔵名、県名を持つjsonの配列
def to_ndjson(names)
  names.map { |region, name|
    { name: name, region: region }
  }
end

# ファイルにNDJSON形式で保存する
#
# @param names [Array<Hash<Symbol => String>] 県名と蔵名を持つjsonの配列
def write_ndjson(ndjson)
  filename = "sakagura-list.ndjson"
  File.open(filename, "wb") do |f|
    ndjson.each do |line_json|
      JSON.dump(line_json, f)
      f.write("\n")
    end
  end
end

def main
  regions = request_regions
  names = request_names(regions)
  names = add_sakagura(names)
  ndjson = to_ndjson(names)
  write_ndjson(ndjson)
end

main
