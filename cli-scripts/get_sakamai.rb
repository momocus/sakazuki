#!/usr/bin/env ruby

# 農林水産省のサイトから酒造好適米の一覧を取得してNDJSONを作るスクリプト
#
# NDJSONには1行に1データが入っており改行で区切られている。
# 内容は
#  {name: String(酒米の名前）}
# となっている。
#
# ホームページにない酒米も一部追加している

require "open-uri"
require "nokogiri"
require "json"

# 農林水産省のウェブページに載っていない新しい酒造好適米を追加する
#
# 知った酒造好適米が農林水産省のページになければ追加する。
# 農林水産省のページに追加されれば削除する。（しなくても正しく動くようにしている。）
# 全都道府県を網羅するつもりは特にない。
#
# @param rices [Array<String>] 酒米のリスト
# @return [Array<String>] 特定の品種が追加された酒米のリスト
def add_rices(rices)
  rices += ["吟のいろは"]       # 宮城県
  rices += ["百万石乃白"]       # 石川県
end

# 農林水産省のページを取得し酒米リストを作成する
#
# 取得した酒米はソートされ重複削除をしてある。
#
# @example 実行例
#   request_rices #=> ["いにしえの舞", "おくほまれ", ...]
#
# @return [Array<String>] 酒米のリスト
def request_rices
  url = "https://www.maff.go.jp/j/kokuji_tuti/kokuji/k0001439.html"
  html = URI.parse(url).open
  doc = Nokogiri::HTML(html).css("div#main_content table")
  # HACK: 農林水産省ページのテーブルに名前がないので、16番目指定で醸造用玄米のテーブルを取得する
  #       またテーブルヘッダがtrタグ指定なので、[1..]でヘッダを削る
  trs = doc[15].css("tr")[1..]
  rices = trs.map { |tr|
    td = tr.css("td")[1]        # HACK: [0]の都道府県名を削る
    not_br = td.children[1]     # HACK: 農林水産省ページのtd内先頭にある<br>を削る
    rices = not_br.text.strip   # HACK: HTMLで入りがちなスペースを削除
    rices.split(/、|及び/)      # HACK: 農林水産省の一覧が「、」と「及び」で区切られている
  }.flatten(lv = 1)
  rices = add_rices(rices)
  rices.sort.uniq
end

# 酒米一覧をNDJSON形式にする
#
# @example 実行例
#   to_ndjson(["いにしえの舞", "おくほまれ"]) #=> [{name:"いにしえの舞"}, {name:"おくほまれ"}]
#
# @param names [Array<String>] 酒米のリスト
# @return [Array<Hash<Symbol => String>] nameキーに酒米の名前を持つjsonの配列
def to_ndjson(rices)
  rices.map { |name|
    { name: name }
  }
end

# ファイルにNDJSON形式で保存する
#
# @param names [Array<Hash<Symbol => String>] 酒米名を持つjsonの配列
def write_ndjson(ndjson)
  filename = "sakamai-list.ndjson"
  File.open(filename, "wb") do |f|
    ndjson.each do |line_json|
      JSON.dump(line_json, f)
      f.write("\n")
    end
  end
end

def main
  rices = request_rices
  ndjson = to_ndjson(rices)
  write_ndjson(ndjson)
end

main
