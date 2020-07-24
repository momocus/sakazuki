module SessionsHelper
  # 渡されたユーザーでログインする
  def sign_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    # rubocop:disable Rails/HelperInstanceVariable
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    # rubocop:enable Rails/HelperInstanceVariable
  end

  def signed_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def sign_out
    session.delete(:user_id)
    @current_user = nil # rubocop:disable Rails/HelperInstanceVariable
  end
end
