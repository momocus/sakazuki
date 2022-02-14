require "era_ja/date"

module SakesHelper
  # nilと空文字列を指定の値に変換する
  # @param value [Object, nil] 対象の値
  # @param default [Object] 空のとき返す値
  # @return [Object] valueをそのまま返すか、valueが空ならdefaultを返す
  def empty_to_default(value, default)
    value.presence || default
  end

  # 日付をBYに変換する
  # @example
  #   to_by(Date(2021, 6, 30)) #=> Date(2020, 7, 1)
  #   to_by(Date(2021, 7, 2)) #=> Date(2021, 7, 1)
  # @param date [Date] 日付
  # @return [Date] 入力された日付に対応するBY、月日はBYの始まりである7/1となる
  def to_by(date)
    by_year = date.year - (date.month >= 7 ? 0 : 1)
    # BYは年のみ、使わない月日はBY始まりの7/1とする
    Date.new(by_year, 7)
  end

  # 和暦付きの年のHTMLセレクタを生成する
  # @param id [String] HTMLのid
  # @param name [String] HTMLのname
  # @param latest_year [Integer] 選択肢の最新年
  # @param selected [Integer, nil] 初期選択年
  # @param include_blank [Boolean] trueなら選択肢に空が含まれる
  # @param args [Object] select_tagにそのまま渡されるoptions
  # @return [String] 年のHTMLセレクタ
  def year_select_with_japanese_era(id:, name:, latest_year:, selected: latest_year, include_blank: false, **args)
    years = year_range(latest_year)
    options = years.map { |year| [with_japanese_era(Date.new(year)), year] }
    options += [[t("sakes.new.unknown"), nil]] if include_blank
    options = options_for_select(options, selected: selected || "") # HACK: ""で空値の不明を選択する
    select_tag(id, options, class: "form-select", name: name, **args)
  end

  # どの瓶状態（bottle_level）にもマッチしない値
  #
  # 酒indexにおいて全ての酒を表示するために使われる。
  # @return [Integer] -1
  def bottom_bottle
    -1
  end

  # @type [Array<String>]
  UNITS = %w[合 升 斗 石].freeze

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
  # @param amount [Integer] 酒の量[ml]
  # @return [String] 尺貫法の体積で表した酒量の文字列
  def to_shakkan(amount)
    if amount < 180
      "0合"
    else
      # rubocop:disable Style/HashExcept
      (amount / 180).to_s.reverse.each_char.zip(UNITS).filter { |value, _unit| value != "0" }.reverse.join
      # rubocop:enable Style/HashExcept
    end
  end

  # 酒蔵の名前から会社の種類を削除し短くする
  #
  # @param kura [String] 蔵名
  # @return [String] 会社の種類を削除した蔵名
  def short_kura(kura)
    kura = kura.gsub("株式会社", "")
    kura = kura.gsub("有限会社", "")
    kura = kura.gsub("合名会社", "")
    kura = kura.gsub("合資会社", "")
    kura.gsub("合同会社", "")
  end

  # 都道府県名から都府県を削除し短くする
  #
  # @param todofuken [String] 都道府県名
  # @return [String] 都府県が削除された都道府県名
  def short_todofuken(todofuken)
    todofuken = todofuken.gsub("東京都", "東京") # 京都対策
    todofuken = todofuken.gsub("府", "")
    todofuken.gsub("県", "")
  end

  # 酒の瓶状態が最後に更新された日付を返す
  #
  # 酒がsealedなら購入した日付、openedなら開封した日付、emptyなら空にした日付を返す。
  #
  # @param sake [Sake] 酒オブジェクト
  # @return [ActiveSupport::TimeWithZone] 最後に瓶状態が更新された日付
  def latest_at(sake)
    case sake.bottle_level
    when "sealed"
      sake.created_at
    when "opened"
      sake.opened_at
    when "empty"
      sake.emptied_at
    end
  end

  # 酒オブジェクトのカラム値に対して、Viewで適用するスタイル名を返す
  #
  # @param value [Object, nil] 酒オブジェクトのカラムの値
  # @return [String] スタイル名
  def either_highlight_or_lowlight(value)
    value.blank? || value == "unknown" ? "lowlight-value" : "highlight-value"
  end

  private

  # 日付を和暦付き文字列に変換する
  # @param date [Date] 日付
  # @return [String] "2021 / 令和3年"のような文字列
  def with_japanese_era(date)
    "#{date.year} / #{date.to_era('%O%-E年')}"
  end

  # 過去何年を酒情報に入力可能にするかの値
  # @type [Integer]
  START_YEAR_LIMIT = 30
  private_constant :START_YEAR_LIMIT

  # 酒情報に入力可能な年範囲を作成する
  # @param begin_year [Integer] 開始年
  # @return [Range<Integer>] 年範囲
  def year_range(begin_year)
    (begin_year - START_YEAR_LIMIT)..begin_year
  end

  private_constant :UNITS
end
