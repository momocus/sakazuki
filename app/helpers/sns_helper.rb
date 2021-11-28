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

  # Facebookシェアボタンを生成する
  #
  # @return [String] 複数のHTMLタグ
  # rubocop:disable Metrics/MethodLength
  def share_facebook_button
    return unless ENV["FB_APP_ID"]

    # share button
    tags = tag.div(class: "fb-share-button",
                   data: {
                     href: request.original_url,
                     layout: "button_count",
                     size: "small",
                   }) {
      tag.a(target: "_blank",
            href: "https://www.facebook.com/sharer/sharer.php" \
                  "?u=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fplugins%2F&amp;src=sdkpreparse",
            class: "fb-xfbml-parse-ignore")
    }
    # Facebook JavaScript SDK
    tags.concat(tag.div(id: "fb-root"))
    tags.concat(tag.script(async: "async",
                           defer: "defer",
                           crossorigin: "anonymous",
                           src: "https://connect.facebook.net/ja_JP/sdk.js" \
                                "#xfbml=1&version=v12.0&appId=1293086151151453&autoLogAppEvents=1",
                           nonce: "huvOAgxZ"))
  end

  # rubocop:enable Metrics/MethodLength
end
