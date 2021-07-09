require "era_ja/date"

module SakesHelper
  def empty_to_default(value, default)
    value.presence || default
  end

  def start_year_limit
    30
  end

  def to_by(date)
    by_year = date.year - (date.month >= 7 ? 0 : 1)
    # BYは年のみ、使わない月日はBY始まりの7/1とする
    Date.new(by_year, 7)
  end

  # @param [Date] date
  def with_japanese_era(date)
    "#{date.year} / #{date.to_era('%O%-E年')}"
  end

  def year_range(begin_year)
    (begin_year - start_year_limit)..begin_year
  end

  # @param [String] id
  # @param [String] name
  # @param [Integer] begin_year
  # @param [Integer] selected_year
  # @param [Boolean] include_blank trueなら選択肢に空が含まれる
  def year_select_with_japanese_era(id, name, begin_year, selected_year = begin_year, include_blank: false)
    options = year_range(begin_year).map do |year|
      [with_japanese_era(Date.new(year)), year]
    end
    if include_blank then options = options + [[t("sakes.new.unknown"), nil]] end
    select_tag(id, options_for_select(options, selected: selected_year), { class: "form-select", name: name })
  end

  # どの瓶状態（bottle_level）にもマッチしない値
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

  private_constant :UNITS
end
