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

  # 過去何年を酒情報に入力可能にするかの値
  # @return [Integer] 年数
  def start_year_limit
    30
  end

  # 現在日時から入力可能なBY年のレンジを作成する
  # @return [Range<Date>] 1年間隔で30年分のBYオブジェクトのレンジ
  def by_range
    this_by = to_by(Time.current).year
    years = (this_by - start_year_limit)..this_by
    years.map { |year| Date.new(year, 7) } # 7/1
  end

  # 日付を和暦付き年の文字列に変換する
  #
  # 7/1の月日を持つBYのDateオブジェクトを渡しても、正しく和暦をつけることができる。
  # @param date [Date] 日付
  # @return [String] "2021 / 令和3年"のような年の文字列
  def with_japanese_era(date)
    "#{date.year} / #{date.to_era('%O%K-E年')}"
  end

  def by_collection
    collection = by_range.map { |d| [with_japanese_era(d), d.to_s] }
    collection.push([I18n.t("sakes.form_abstract.unknown"), ""])
  end

  # Dateオブジェクトの日付を1にする
  #
  # @param date [Date] 対象の日付
  # @return [Date] 日付を1日にしたDate
  def to_day_one(date)
    Date.new(date.year, date.month)
  end

  # 指定された期間で年月のレンジを作成する
  #
  # 作成されるレンジのステップは1ヶ月となる。
  #
  # @example 4500 mlは2升5合
  #   month_range(Date.parse("2022-12-06", Date.parse("2023-01-06") #=> [2022-12-01, 2023-01-01]のようなレンジ
  #
  # MEMO:
  # Dateクラスのレンジオブジェクトを作るため、効率が悪い。
  # 具体的な使用例でいうと、30年×365日分のオブジェクトが一時的に作られる。
  # 現状はコードの綺麗さを重視し、動作の重さが気になったら更新する。
  #
  # @param first [Date] 最初の年月
  # @param last [Date] 最後の年月
  # @return [Range<Date>] 年月のレンジオブジェクト
  def month_range
    first = Time.current.ago(start_year_limit.years)
    last = Time.current
    (first.to_date..last.to_date).map { |d| to_day_one(d) }.uniq
  end

  # 製造年月の候補を作成する
  #
  # 現在の日付から30年分を生成する
  #
  # @return [Array<String, String>] 製造年月セレクタで使う、表示用文字列と日付データ
  def bindume_collection
    month_range.map { |d|
      year = with_japanese_era(d)
      month = I18n.l(d, format: "%B")
      ["#{year} #{month}", d.to_s]
    }
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
  private_constant :UNITS

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

  # お品書きで酒の値札として表示する文字列を返す
  #
  # selling_price がnilの場合は"時価"を返す.
  # そうでなければ、selling_priceに単位をつけて"xxx円"を返す。
  # @param selling_price [Integer, nil] 売値またはnil
  # @return [String] 酒の値札として表示する文字列
  def price_tag(selling_price)
    return t("sakes.menu.market_price") if selling_price.nil?

    "#{selling_price}#{t('activerecord.attributes.sake.price_unit')}"
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

  # ヘッダタイトル用に検索ワードつきのタイトルを生成する
  #
  # @param search [String, nil] 検索ワード
  # @return [String] ヘッダタイトル
  def title_with_search(search)
    prefix = search.present? ? "#{search} - " : ""
    "#{prefix}#{t('sakes.index.title')}"
  end

  # 酒index用に酒の総量つきのタイトルを生成する
  #
  # @param include_empty [Boolean] trueなら空き瓶込みでカウントする
  # @return [String] 酒の総量つきタイトル
  def title_with_stock(include_empty)
    stock = to_shakkan(Sake.alcohol_stock(include_empty:))
    "#{t('sakes.index.title')} - #{stock}"
  end
end
