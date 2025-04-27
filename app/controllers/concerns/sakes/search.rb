module Sakes
  module Search
    extend ActiveSupport::Concern

    included do
      # Define any shared logic or setup here if needed
    end

    private

    def to_multi_search!(query)
      words = query.delete(:all_text_cont)
      query[:groupings] = separate_words(words)
    end

    def separate_words(words)
      # 全角空白または半角空白で区切ることを許可
      # { :name_cont => "" }があり得るがransackがSQL変換で削除するのでOK
      words.split(/[ 　]/).map { |word| { all_text_cont: word } }
    end
  end
end
