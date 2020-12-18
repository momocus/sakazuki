module DeviseHelper
  # deviseが生成するメッセージタイプだった場合、
  # bootstrapのアラートタイプに変換する。
  # deviseが生成するメッセージタイプ3種と変換先は以下の通り。
  #   "notice"   => "success"  ex. ログイン成功
  #   "alert"    => "danger"   ex. パスワードミス
  #   "timedout" => 変換しない ex. タイムアウト
  def bootstrap_alert(message_type)
    case message_type
    when "notice" then "success"
    when "alert" then "danger"
    else message_type
    end
  end

  def minimum_password_message(minimum_password_length)
    if minimum_password_length
      t("devise.shared.minimum_password_length", count: minimum_password_length)
    else
      ""
    end
  end
end
