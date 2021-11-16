#!/bin/bash

# 対象ファイルのリスト
#   Gitの管理下でcacheされているファイルを対象とする
#   除外するファイルは以下
#     - Railsによる空ディレクトリキープのための.keep
#     - 画像ファイル
#     - 暗号化された.yml.enc
files=$(git ls-files | \
            grep --invert-match '\.keep$' | \
            grep --invert-match '\.png$' | \
            grep --invert-match '\.ico$' | \
            grep --invert-match '\.yml\.enc$')

error_files=""
for file in ${files}; do
    # 改行で終わってないファイルを探し記録する
    # 参考: https://qiita.com/BlackCat_617/items/c0d7f7378bc55b3e07d0
    if [ `tail -n 1 ${file} | wc -l` == 0 ]; then
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
