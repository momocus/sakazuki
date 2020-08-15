#!/bin/bash

# 対象ファイルのリスト
#   一部パスを除外している
#   対象は拡張子で指定している
files=$(find . \
             -not -path "./node_modules/*" -not -path "./public/*" \
             -not -path "./vendor/*" \
             -type f -regex '.*\.\(rb\|erb\|css\|scss\|js\|ts\|yml\)')

error_files=""
for file in ${files}; do
    # 改行で終わってないファイルを探し記録する
    # 参考: https://qiita.com/BlackCat_617/items/c0d7f7378bc55b3e07d0
    if [ `tail --lines=1 ${file} | wc --lines` == 0 ]; then
        error_files="${error_files} ${file}"
    fi
done

if [ "${error_files}" == "" ]; then
    echo "Good."
    exit 0
else
    echo "[ERROR] There are some files without newline in end of file."
    for file in ${error_files}; do
        echo "  ${file}"
    done
    exit 1
fi
