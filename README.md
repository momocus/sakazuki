# Sakazuki

自宅の酒を管理するアプリケーション

# Requirements

- Ruby >= 2.7.1
- Rails >= 6.0.3.2
- Yarn🐈 >= 1.22.4

# How to use

- 依存関係のインストール
    - `bundle install`
    - `yarn install --check-files`
- メーラの設定
    - ユーザのメールアドレスに通知するために使われる
```yaml
# config/setting.local.yml
mail:
     smtp: "smtp.gmail.com"
     domain: "gmail.com"
     port: 587
     user_name: "your_mail_address@gmail.com"
     password: "your_gmail_password"
```
- 最初のユーザの設定
    - `bundle exec rails db:seed`
- サーバの起動
    - `bundle exec rails server`
- http://localhost:3000/ へアクセスする
- ログイン
    - メールアドレス: `example@example.com`
    - パスワード: `rootroot`
- localユーザの設定
    - まだ

# How to Contribute

- まだ
