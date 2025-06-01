module SakesSearch
  extend ActiveSupport::Concern

  included do
    # Define any shared logic or setup here if needed
  end

  private

  # クエリを初期化する
  #
  # @param query [Hash{Symbol => String}, nil] クエリパラメータ
  # @return [Hash] not nilなコピーされたクエリ
  def initialize_query(query)
    query ? query.deep_dup : {}
  end

  # 空き瓶を表示するかどうか
  #
  # @param query [Hash{Symbol => String}] クエリパラメータ
  # @return [Boolean] 空き瓶を表示するならtrue
  def include_empty?(query)
    !query.nil? and query[:bottle_level_not_eq] == Sake::BOTTOM_BOTTLE.to_s
  end

  # クエリにデフォルトの瓶状態を設定する
  #
  # クエリの瓶状態が設定されていないときは、空き瓶の表示をオフにする。
  #
  # @param query [Hash{Symbol => String}] クエリパラメータ
  # @return [void]
  def to_default_bottle!(query)
    query[:bottle_level_not_eq] = Sake.bottle_levels["empty"]
  end

  # 文字列を空白で分割して検索用文字列を生成する
  #
  # 文字列の分割には、全角空白と半角空白が認められる。
  #
  # @param words [String] 検索文字列
  # @return [Array<Hash>] 分割された検索文字列
  def separate_words(words)
    # MEMO:
    # 例えば、" 愛知 原田"のとき["", "愛知", "原田"]のように空文字列が入りうる。
    # 結果、このあとRansackに投げるクエリに{ "all_text_cont" => "" }が入りうる。
    # しかし、Ransackはこの空文字列を削除してSQL変換してくれるので、問題にならない。
    words.split(/[ 　]/).map { |word| { all_text_cont: word } }
  end

  # クエリを複数検索用に変換する
  #
  # @param query [Hash] クエリパラメータ
  # @return [void]
  def to_multi_search!(query)
    words = query.delete(:all_text_cont)
    query[:groupings] = separate_words(words)
  end
end
