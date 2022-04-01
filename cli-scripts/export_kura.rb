#!/usr/bin/env ruby

# kura-list.ndjsonを使って、_kura-datalist.html.erbを生成するスクリプト

require "json"

# ファイルに開きタグを書き込む
#
# @param file [File] 書き込み先のファイルオブジェクト
def write_header(file)
  file.write("<datalist id=\"kura-list\">\n")
end

# ファイルに閉じタグを書き込む
#
# @param file [File] 書き込み先のファイルオブジェクト
def write_footer(file)
  file.write("</datalist>\n")
end

# ファイルにdatalistを書き込む
#
# @param output_file [File] 書き込み先のファイルオブジェクト
def write_body(output_file)
  input_file = "kura-list.ndjson"
  File.foreach(input_file, chomp: true) do |line|
    json = JSON.parse(line)
    name = json["name"]
    todofuken = json["region"]
    option_tag = "  <option value=\"#{name}（#{todofuken}）\"></option>\n"
    output_file.write(option_tag)
  end
end

def main
  output_file = "../app/views/sakes/_kura-datalist.html.erb"
  File.open(output_file, "wb") do |out|
    write_header(out)
    write_body(out)
    write_footer(out)
  end

  puts("Done!")
  puts("Output to '#{output_file}'")
end

main
