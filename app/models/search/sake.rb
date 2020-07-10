class Search::Sake < Search::Base
  attr_accessor :word
  attr_accessor :only_in_stock

  def filter
    results = ::Sake.all
    if word.present?
      result1 = contain(results,"name",word)
      result2 = contain(results,"kura",word)
      result3 = contain(results,"tokutei_meisho",word)
      results = result1.or(result2).or(result3)
    end

    if value_to_boolean(only_in_stock)
      results = exclude(results,"bottle_state","2")
    end

    return results
  end

end