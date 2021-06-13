module SignInModule
  # ヘッダーのSign inボタンをクリックし、サインインする
  def sign_in_via_header_button(user)
    find(:test_id, "sign-in").click
    fill_sign_column(user)
  end

  # Sign inページにてemail、passwordを入力し、サインインする
  def fill_sign_column(user)
    fill_in("user_email", with: user.email)
    fill_in("user_password", with: user.password)
    click_button("commit")
  end
end
