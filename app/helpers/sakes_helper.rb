module SakesHelper
  def search_query
    # rubocop:disable Layout/LineLength
    :aroma_impression_or_awa_or_color_or_genryomai_or_kakemai_or_kobo_or_kura_or_name_or_nigori_or_note_or_roka_or_season_or_shibori_or_taste_impression_or_todofuken_cont
    # rubocop:enable Layout/LineLength
  end

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
