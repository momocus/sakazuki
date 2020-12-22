module TweetHelper
  def tweet_button(tweet_text)
    hashed_twitter = "https://twitter.com/intent/tweet?button_hashtag=Sakazuki&ref_src=twsrc%5Etfw"
    tag.a "Tweet",
          href: hashed_twitter,
          class: "twitter-hashtag-button",
          data: { text: tweet_text, show_count: false }
  end

  def add_postfix(text, postfix, period = "")
    postfix.empty? ? text : "#{postfix}#{period}#{text}"
  end

  # 酒の香りなどに「。」があったりなかったりする可能性があるため、
  # PREFIXEにPERIODがない場合は自動で付加する。
  def add_prefix(text, prefix, period = "")
    if prefix.empty? then text
    elsif prefix.end_with? period then "#{text}#{prefix}"
    else "#{text}#{prefix}#{period}" end
  end

  # 酒の名前のみがnon nilのため、他パラメータは空の場合を考慮する。
  def make_text(name, kura, color, aroma, taste)
    text = "#{name}#{t('helpers.tweet.punctuation')}"
    text = add_postfix(text, kura.gsub("株式会社", "㈱").to_s, t("helpers.tweet.honorific_title"))
    text = add_prefix(text, color, t("helpers.tweet.punctuation"))
    text = add_prefix(text, aroma, t("helpers.tweet.punctuation"))
    add_prefix(text, taste, t("helpers.tweet.punctuation"))
  end
end
