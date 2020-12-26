module TweetHelper
  def tweet_button(tweet_text)
    share_twitter = "https://twitter.com/share?ref_src=twsrc%5Etfw"
    tag.a "Tweet",
          href: share_twitter,
          class: "twitter-share-button",
          data: { text: tweet_text, hashtags: "Sakazuki", show_count: false }
  end

  def add_period(text, period = t("helpers.tweet.punctuation"))
    if text.empty? || text.end_with?(period) then text
    else "#{text}#{period}" end
  end

  def to_kakkokabu(text)
    text.gsub("株式会社", "㈱").to_s
  end

  # 酒の名前のみがnon nilのため、他パラメータは空の場合を考慮する。
  def make_text(name, kura, color, aroma, taste)
    kura = add_period(to_kakkokabu(kura), t("helpers.tweet.honorific_title"))
    name = add_period(name)
    color = add_period(color)
    aroma = add_period(aroma)
    taste = add_period(taste)
    "#{kura}#{name}#{color}#{aroma}#{taste}"
  end
end
