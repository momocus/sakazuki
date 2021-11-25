module SnsHelper
  # Tweetボタンを生成する
  #
  # @param tweet_text [String] ツイートボタンを押したときのツイート内容
  # @return [String] TweetボタンのHTMLタグ
  def tweet_button(tweet_text)
    share_twitter = "https://twitter.com/share?ref_src=twsrc%5Etfw"
    tags = tag.a("Tweet",
                 href: share_twitter,
                 class: "twitter-share-button",
                 data: { text: tweet_text, hashtags: "SAKAZUKI", show_count: false })
    tags.concat(tag.script(async: "async", src: "https://platform.twitter.com/widgets.js", charset: "utf-8"))
  end
end
