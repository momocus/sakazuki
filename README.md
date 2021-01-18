![Generic Checks](https://github.com/momocus/sakazuki/workflows/Generic%20Checks/badge.svg)
![JavaScript and TypeScript](https://github.com/momocus/sakazuki/workflows/JavaScript%20and%20TypeScript/badge.svg)
![Ruby](https://github.com/momocus/sakazuki/workflows/Ruby/badge.svg)

# Sakazuki

自宅の酒を管理するアプリケーション

# Requirements

- Ruby = 2.7.2
- Bundler
- Yarn🐈 >= 1.22.4
- Node.js >= 12.20.1
- PostgreSQL >= 12.0

# How to use

- 依存関係のインストール
    - `bundle install`
    - `yarn install --check-files`
- PostgreSQLのユーザの設定
    - PostgreSQLへの接続に使われる
```shell
# .envファイルに記載 or 環境変数に設定
POSTGRESQL_NAME=your_postgresql_name
POSTGRESQL_PASS=your_postgresql_password
```
- 最初のユーザの設定
    - `bundle exec rails db:seed`
- サーバの起動
    - `bundle exec rails server`
- http://localhost:3000/ へアクセスする
- 最初の管理者ユーザの設定（オプション）
    - Sakazukiへのログインに使われる
```ruby
# db/seed.rb
User.create!(
  email: "<your emacs address>",      # この2行を
  password: "your account password>", # 編集する
  admin: true,
)
```
- ログイン
    - メールアドレス: `example@example.com`
    - パスワード: `rootroot`
    - または前項で書き換えた内容でログイン
- localユーザの設定
    - まだ
- 送信メールの確認
    - http://localhost:3000/letter_opener にアクセス

# How to deploy to heroku

本番環境では、実際にメールの送受信をする、画像をCloudinaryにアップロードするという点が開発環境と異なる。デプロイする前にこれらの設定が必要。

- メーラの設定
    - ユーザのメールアドレスに通知するために使われる
```yaml
# config/credentials/production.yml.enc
# EDITOR="好きなエディタ" bin/rails credentials:edit --environment production にて開く
mail:
     smtp: "smtp.gmail.com"
     domain: "gmail.com"
     port: 587
     user_name: "your_mail_address@gmail.com"
     password: "your_gmail_password"
```
- Cloudinaryの設定
  - 画像アップロード用のクラウドサービスCloudinaryの接続に使われる。
```yaml
# config/credentials/production.yml.enc
# EDITOR="好きなエディタ" bin/rails credentials:edit --environment production にて開く
cloudinary:
     cloud_name: your_cloud_name
     api_key: your_api_key
     api_secret: your_api_secret
     enhance_image_tag: true
     static_file_support: false
```
- CredentialsのKeyを登録
  - Credentialsで暗号化されたファイルを復号するためのKeyを登録する。
  - `heroku config:set RAILS_MASTER_KEY=`cat config/credentials/production.key`
    - ※production.keyファイルはメーラとCloudinaryの設定をしたときに作られる。

# How to Contribute

- まだ
