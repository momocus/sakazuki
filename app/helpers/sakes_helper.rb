module SakesHelper
  def empty_to_default(value, default)
    value.presence || default
  end

  def start_year_limt
    30
  end

  def to_by(date)
    by_year = date.year - (date.month >= 7 ? 0 : 1)
    # BYは年のみ、使わない月日はBY始まりの7/1とする
    Date.new(by_year, 7)
  end
end
