module Sakes
  module Search
    extend ActiveSupport::Concern

    included do
      # Define any shared logic or setup here if needed
    end

    private

    def initialize_query(query)
      query ? query.deep_dup : {}
    end

    # 空き瓶を表示するかどうかを調べる
    #
    # @param query [Hash{Symbol => String}] params[:q]に格納されたRansackのクエリ
    # @return [Boolean] 空き瓶も込みで表示するならtrueを返す
    def include_empty?(query)
      !query.nil? and query[:bottle_level_not_eq] == Sake::BOTTOM_BOTTLE.to_s
    end

    def to_default_bottle!(query)
      query[:bottle_level_not_eq] = Sake.bottle_levels["empty"]
    end

    def separate_words(words)
      # 全角空白または半角空白で区切ることを許可
      # { :name_cont => "" }があり得るがransackがSQL変換で削除するのでOK
      words.split(/[ 　]/).map { |word| { all_text_cont: word } }
    end

    def to_multi_search!(query)
      words = query.delete(:all_text_cont)
      query[:groupings] = separate_words(words)
    end
  end
end
