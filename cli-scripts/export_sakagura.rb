#!/usr/bin/env ruby

# sakagura-list.ndjsonを使って、sakagura-datalist.html.erbを生成するスクリプト

require "json"

def write_header(file)
  file.write("<datalist id=\"sakagura\">\n")
end

def write_footer(file)
  file.write("</datalist>\n")
end

def write_body(output_file)
  input_file = "sakagura-list.ndjson"
  File.foreach(input_file, chomp: true) do |line|
    json = JSON.parse(line)
    name = json["name"]
    todofuken = json["region"]
    option_tag = "  <option value=\"#{name}（#{todofuken}）\"></option>\n"
    output_file.write(option_tag)
  end
end

def main
  output_file = "../app/views/sakes/_sakagura-datalist.html.erb"
  File.open(output_file, "wb") do |out|
    write_header(out)
    write_body(out)
    write_footer(out)
  end
end

main
