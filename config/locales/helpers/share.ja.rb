module ShareHelperJa
  # 文末に句点がない場合は追加する
  # @param text [String] 対象テキスト
  # @param period [String] 句点、デフォルトは。
  # @return [String] 句点を追加したテキスト
  def add_period(text, period = I18n.t("helper.share.punctuation"))
    text.empty? || text.end_with?(period) ? text : "#{text}#{period}"
  end

  # 蔵名中の法人を表す文字列を略語に変換する
  #
  # @see https://0g0.org/ 囲み文字
  # @see https://hiramatu-hifuka.com/onyak/kotoba-1/hojin.html 法人等略語一覧表
  # @param text [String] 蔵名を含む文字列
  # @return [String] 法人名が略語になった文字列
  def to_enclosed(text)
    text = text.gsub("株式会社", "㈱")
    text = text.gsub("有限会社", "㈲")
    text = text.gsub("合名会社", "㈴")
    text = text.gsub("合資会社", "㈾")
    text.gsub("合同会社", "(同)")
  end

  # 酒の情報からツイートメッセージを生成する
  #
  # @param name [String] 酒の名前
  # @param kura [String] 酒の蔵名
  # @param color [String] 酒の色
  # @param aroma [String] 酒の香り
  # @param taste [String] 酒の味
  # @return [String] ツイートメッセージ
  def make_text(name, kura, color, aroma, taste)
    # 酒の名前のみがnon nil、他パラメータは空の場合を考慮する。
    kura = to_enclosed(kura)
    kura = add_period(kura, I18n.t("helper.share.honorific_title"))
    name = add_period(name)
    color = add_period(color)
    aroma = add_period(aroma)
    taste = add_period(taste)
    "#{kura}#{name}#{color}#{aroma}#{taste} \#SAKAZUKI"
  end

  module_function :to_enclosed
  module_function :add_period
  module_function :make_text
end

{
  ja: {
    helper: {
      share: {
        punctuation: "。",
        honorific_title: "さんの",
        text: lambda { |_key, options|
          sake = options[:sake]
          ShareHelperJa.make_text(sake.name, sake.kura, sake.color, sake.aroma_impression, sake.taste_impression)
        },
      },
    },
  },
}
