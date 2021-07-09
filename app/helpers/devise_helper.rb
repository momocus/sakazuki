module DeviseHelper
  # deviseが生成するメッセージタイプをbootstrapのアラートタイプに変換する
  #
  # deviseが生成するメッセージタイプ3種と変換先はexampleの通り。
  # @example
  #   bootstrap_alert("notice") #=> "success" ex. ログイン成功
  #   bootstrap_alert("alert") #=> "danger" ex. パスワードミス
  #   bootstrap_alert("timedout") #=> "timedout" ex. タイムアウト
  # @param [String] message_type deviseが生成するメッセージタイプ
  # @return [String] bootstrapのアラートタイプ
  def bootstrap_alert(message_type)
    case message_type
    when "notice" then "success"
    when "alert" then "danger"
    else message_type
    end
  end

  # パスワードの文字数制約メッセージ
  # @example
  #   minimum_password_message(6) #=> "（6文字以上）"
  #   minimum_password_message(nil) #=> ""
  # @param [Integer, nil] minimum_password_length パスワードの最小文字数
  # @return [String] （n文字以上）という文字列または空文字
  def minimum_password_message(minimum_password_length)
    if minimum_password_length
      t("devise.shared.minimum_password_length", count: minimum_password_length)
    else
      ""
    end
  end
end
