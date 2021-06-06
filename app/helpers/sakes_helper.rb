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

  # どの瓶状態（bottle_level）にもマッチしない値
  def bottom_bottle
    -1
  end

  # 酒が未開封か
  # @param [Sake] 酒
  # @return [Boolean] 酒が未開封ならture、さもなくばfalse
  def sealed?(sake)
    sake.bottle_level == "sealed"
  end

  # 酒が開封されてまだ残っているか
  # @param [Sake] 酒
  # @return [Boolean] 酒が開封済みで中身が残っていたらture、未開封や空ならfalse
  def opened?(sake)
    sake.bottle_level == "opened"
  end

  # 酒が未評価か
  # @param [Sake] 酒
  # @return [Boolean] 酒の味・香りが評価されていないとtrue、評価済みならfalse
  def unimpressed?(sake)
    sake.taste_value.nil? && sake.aroma_value.nil?
  end
end
