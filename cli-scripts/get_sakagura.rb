#!/usr/bin/env ruby

require "open-uri"
require "nokogiri"
require "json"

# SakeTimesの酒蔵一覧を使ってNDJSONを作るスクリプト
#
# NDJSONには1行に1データが入っており改行で区切られている。
# 内容は
#  {"id": Integer(uniq), "name": String(酒蔵名）, "region": String(都道府県名)}
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

# SakeTimesの酒蔵一覧ページから、URLと都道府県名のhashを作る
#
# hash内容は以下のようなstring keyからstringへのhashである。
#   { "https://jp.sake-times.com/sakagura/./hokkaido" => "北海道", ... }
# このhashを使うことで、サブページから酒蔵一覧を取得することができる。
def request_todofuken
  base_url = "https://jp.sake-times.com/sakagura/"
  html = URI.parse(base_url).open
  doc = Nokogiri::HTML(html).css("ul.sakayagura-list li a")
  regions = {}
  doc.each do |a|
    url = a.attributes["href"].value
    # # URL末尾の"hokkaido"だけにする
    # region_url = url.gsub(%r{#{base_url}./}, "")

    # "北海道（13）"のようになっているので、括弧と数字を削る
    ja = a.content.gsub(/\uff08.*\uff09/, "")

    regions[url] = ja
  end
  regions
end

# 酒蔵の社名の変更を適用する
def fix_sakagura_name(name)
  name.gsub(/阿部勘酒造店/, "阿部勘酒造株式会社")
end

# SakeTimesの酒蔵一覧を取得し、ファイルにNDJSON形式で保存する
def write_ndjson(regions)
  filename = "sakagura-list.ndjson"
  File.open(filename, "wb") do |f|
    index = 0
    regions.keys.map do |url|
      html = URI.parse(url).open
      doc = Nokogiri::HTML(html).css("table span.main a")
      doc.each do |table|
        name = fix_sakagura_name(table.content)
        JSON.dump({ id: index, name: name, region: regions[url] }, f)
        f.write("\n")
        index += 1
      end
    end
  end
end

def main
  regions = request_todofuken
  write_ndjson(regions)
end

main
