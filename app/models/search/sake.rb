module Search
  class Sake < Search::Base
    attr_accessor :word, :only_in_stock

    def filter
      results = ::Sake.all
      results = word_filter(results) if word.present?
      results
    end

    private

    def word_filter(data)
      result1 = contain(data, "name", word)
      result2 = contain(data, "kura", word)
      result3 = contain(data, "tokutei_meisho", word)
      result1.or(result2).or(result3)
    end
  end
end
