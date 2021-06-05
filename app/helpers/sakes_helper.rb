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
    [date.year, " / ", date.to_era("%O%-E年")].join
  end

  # @param [String] id
  # @param [String] name
  # @param [Integer] begin_year
  # @param [Integer] selected_year
  def year_select_with_japanese_era(id, name, begin_year, selected_year = begin_year)
    year_range = begin_year - start_year_limit..begin_year
    options = year_range.collect do |year|
      [with_japanese_era(to_by(Date.new(year + 1))), year]
    end
    select_tag id, options_for_select(options, selected: selected_year), class: "form-control", name: name
  end

  # どの瓶状態（bottle_level）にもマッチしない値
  def bottom_bottle
    -1
  end
end
