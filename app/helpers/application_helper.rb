module ApplicationHelper
  # ツイートボタンを表示するためのメタタグを挿入する
  # @return [String] ツイッターのHTMLメタタグ
  def twitter_meta_tags
    display_meta_tags(twitter: { card: "summary" },
                      og: { title: "SAKAZUKI" })
  end
end
