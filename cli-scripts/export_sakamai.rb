#!/usr/bin/env ruby

require "json"

# ファイルに開きタグを書き込む
#
# @param file [File] 書き込み先のファイルオブジェクト
def write_header(file)
  file.write("<datalist id=\"sakamai-list\">\n")
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
  input_file = "sakamai-list.ndjson"
  File.foreach(input_file, chomp: true) do |line|
    json = JSON.parse(line)
    name = json["name"]
    option_tag = "  <option value=\"#{name}\"></option>\n"
    output_file.write(option_tag)
  end
end

def main
  output_file = "../app/views/sakes/_sakamai-datalist.html.erb"
  File.open(output_file, "wb") do |out|
    write_header(out)
    write_body(out)
    write_footer(out)
  end
end

main
