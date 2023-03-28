module DeviseHelper
  # パスワードの文字数制約メッセージ
  # @example
  #   minimum_password_message(6) #=> "（6文字以上）"
  #   minimum_password_message(nil) #=> ""
  # @param minimum_password_length [Integer, nil] パスワードの最小文字数
  # @return [String] （n文字以上）という文字列または空文字
  def minimum_password_message(minimum_password_length)
    if minimum_password_length
      t("devise.shared.minimum_password_length", count: minimum_password_length)
    else
      ""
    end
  end
end
