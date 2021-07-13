class ApplicationController < ActionController::Base
  after_action :store_location

  def signed_in_user
    return if user_signed_in?

    # 未ログインユーザーが酒作成・編集しようとしたときにパスを保存する
    store_location
    flash[:danger] = t("devise.failure.unauthenticated")
    redirect_to(new_user_session_path)
  end

  # サインイン時にユーザーが元いたパスへ戻れるようにするため、
  # deviseのstore_location_forを使ってユーザーが居たパスを保存する
  def store_location
    if storable_location?
      store_location_for(:user, request.fullpath)
    end
  end

  # flashメッセージ内に表示するリンクを生成する
  # @example
  #   alert_link_tag("text","path/to/somewhere") #=> "<a class="alert-link" href="path/to/somewhere">text</a>"
  # @param text [String] 表示するテキスト
  # @param path [String] リンクするパス
  # @return [String] アンカーリンク
  def alert_link_tag(text, path)
    view_context.link_to(text, path, { class: "alert-link" })
  end

  private

  # 下記すべての条件を満たすとき、ユーザーが居たパスを保存してよいと判定する。
  # - リクエストがGETメソッドである。
  # - Ajaxリクエストではない。
  # - ユーザー認証ページへのパスではない。
  #   （リダイレクトループが発生するのを避けるため）
  # 参考: https://github.com/heartcombo/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
  # @return [Boolean] ユーザーが居たパスを保存していいときにtrueを返す。
  def storable_location?
    request.get? && !request.xhr? && !request.path.match?("\/users\/.*")
  end
end
