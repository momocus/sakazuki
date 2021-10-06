module SignIn
  # ヘッダーのSign inボタンをクリックし、サインインする
  # @param user [Object] ファクトリーボットで作ったuserオブジェクト
  def sign_in_via_header_button(user)
    find(:test_id, "sign-in").click
    signin_process_on_signin_page(user)
  end

  # email、passwordを入力し、サインインボタンをクリックする
  # @param user [Object] ファクトリーボットで作ったuserオブジェクト
  # @raise [RuntimeError] 現在のページがSign inページではない場合
  def signin_process_on_signin_page(user)
    raise("signin_process_on_signin_page: called on not sign in page") if current_path != new_user_session_path

    fill_in("user_email", with: user.email)
    fill_in("user_password", with: user.password)
    click_button("commit")
  end
end
