class ApplicationController < ActionController::Base
  after_action :store_location

  def signed_in_user
    return if user_signed_in?

    # 未ログインユーザーが酒作成・編集しようとしたときにパスを保存する
    store_location
    flash[:danger] = "Please sign in."
    redirect_to(new_user_session_path)
  end

  # 以下の場合にユーザーが居たパスを保存する
  # - リクエストがGETメソッドである。
  # - Ajaxリクエストではない。
  # - ユーザー認証ページへのパスではない。
  #   （リダイレクトループが発生するのを避けるため）
  def store_location
    if request.get? &&
       !request.xhr? &&
       !request.path.match?("\/users\/.*")
      store_location_for(:user, request.fullpath)
    end
  end
end
