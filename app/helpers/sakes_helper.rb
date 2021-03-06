require "era_ja/date"

module SakesHelper
  # nilと空文字列を指定の値に変換する
  # @param [Object, nil] value 対象の値
  # @param [Object] default 空のとき返す値
  # @return [Object] valueをそのまま返すか、valueが空ならdefaultを返す
  def empty_to_default(value, default)
    value.presence || default
  end

  # 日付をBYに変換する
  # @example
  #   to_by(Date(2021, 6, 30)) #=> Date(2020, 7, 1)
  #   to_by(Date(2021, 7, 2)) #=> Date(2021, 7, 1)
  # @param [Date] date 日付
  # @return [Date] 入力された日付に対応するBY、月日はBYの始まりである7/1となる
  def to_by(date)
    by_year = date.year - (date.month >= 7 ? 0 : 1)
    # BYは年のみ、使わない月日はBY始まりの7/1とする
    Date.new(by_year, 7)
  end

  # 和暦付きの年のHTMLセレクタを生成する
  # @param [String] id HTMLのid
  # @param [String] name HTMLのname
  # @param [Integer] begin_year 開始年
  # @param [Integer] selected_year 初期選択年
  # @param [Boolean] include_blank trueなら選択肢に空が含まれる
  # @return [String] 年のHTMLセレクタ
  def year_select_with_japanese_era(id, name, begin_year, selected_year: begin_year, include_blank: false)
    options = year_range(begin_year).map do |year|
      [with_japanese_era(Date.new(year)), year]
    end
    if include_blank then options = options + [[t("sakes.new.unknown"), nil]] end
    select_tag(id, options_for_select(options, selected: selected_year), { class: "form-select", name: name })
  end

  # どの瓶状態（bottle_level）にもマッチしない値
  #
  # 酒indexにおいて全ての酒を表示するために使われる。
  # @return [Integer] -1
  def bottom_bottle
    -1
  end

  # @type [Array<String>]
  UNITS = %w[合 升 斗 石]

  # 酒の量[ml]を尺貫法の体積にした文字列で返す
  #
  # @example 4500 mlは2升5合
  #   to_shakkan(4500) #=> "2升5合"
  # @example 300 mlのような数は端数切り捨てされて1合になる
  #   to_shakkan(300) #=> "1合"
  # @example 石より大きな単位はないため、10石を越えても新たな単位はつかない
  #   to_shakkan(2_222_100) #=> "12石3斗4升5合"
  # @example 1斗ぴったりでは升や合は省略される
  #   to_shakkan(18000) #=> "1斗"
  # @example 0には合をつけて返す
  #   to_shakkan(0) #=> "0合"
  # @example 180ml未満は0合を返す
  #   to_shakkan(100) #=> "0合"
  # @param [Integer] amount 酒の量[ml]
  # @return [String] 尺貫法の体積で表した酒量の文字列
  def to_shakkan(amount)
    if amount < 180
      "0合"
    else
      (amount / 180).to_s.reverse.each_char.zip(UNITS).filter { |value, _| value != "0" }.reverse.join
    end
  end

  private

  # 過去何年を酒情報に入力可能にするかの値
  # @return [Integer] 年数
  def start_year_limit
    30
  end

  # 日付を和暦付き文字列に変換する
  # @param [Date] date 日付
  # @return [String] "2021 / 令和3年"のような文字列
  def with_japanese_era(date)
    "#{date.year} / #{date.to_era("%O%-E年")}"
  end

  # 酒情報に入力可能な年範囲を作成する
  # @param [Integer] begin_year 開始年
  # @return [Range<Integer>] 年範囲
  def year_range(begin_year)
    (begin_year - start_year_limit)..begin_year
  end

  private_constant :UNITS
end
