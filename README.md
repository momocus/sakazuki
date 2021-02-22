# Sakazuki

![Check](https://github.com/momocus/sakazuki/workflows/Check/badge.svg)
![Test](https://github.com/momocus/sakazuki/workflows/Test/badge.svg)

自宅の酒を管理するアプリケーション

## Requirements

- Ruby = 2.7.2
- Bundler
- Yarn🐈 >= 1.22.4
- Node.js >= 12.20.1
- PostgreSQL >= 12.0

## How to use

- 依存関係のインストール
  - `bundle install`
  - `yarn install --check-files`
- PostgreSQLのユーザの設定
  - PostgreSQLへの接続に使われる

```console
cp dotenv.example .env
```

```shell
# .env
POSTGRES_USERNAME=your_postgresql_name
POSTGRES_PASSWORD=your_postgresql_password
```

- 管理者ユーザの設定（オプション）
  - 管理者ユーザのメールアドレスとパスワードを設定する

```ruby
# db/seed.rb
User.create!(
  email: "<your emacs address>",      # この2行を
  password: "your account password>", # 編集する
  admin: true,
  confirmed_at: Time.current,
)
```

- 管理者ユーザの作成
  - `bundle exec rails db:seed`
- サーバの起動
  - `bundle exec rails server`
- Sakazukiへのログイン
  - <http://localhost:3000/>へアクセスする
  - メールアドレス: `example@example.com`
  - パスワード: `rootroot`
  - または前項で書き換えた内容でログイン
- localユーザの設定
  - まだ

### How to recieve EMail from Sakazuki in development environment

Sakazukiにてユーザのパスワードリセットはメールで通知される。
Development環境では、letter_openerを使ってメールを確認する。

- <http://localhost:3000/letter_opener>にアクセス

## How to deploy to Heroku

SakazukiはHerokuで動かせる。
Sakazukiの画像はCloudinaryにアップロードされるため、Herokuで使うにはメールとCloudinaryの設定が必要。
2つの設定はRailsのcredentialsを使って管理する。

- メールとCloudinaryの設定

```console
# デフォルトの設定の削除
$ rm config/credentials/production.yml.enc
$ rm config/credentials/production.key
# config/credentials/production.yml.encを編集する
$ EDITOR="好きなエディタ" bundle exec rails credentials:edit --environment production
# config/credentials/production.yml.encとconfig/credentials/production.keyが生成される
```

```yaml
# config/credentials/production.yml.enc
mail:
    smtp: "smtp.gmail.com"
    domain: "gmail.com"
    port: 587
    user_name: "your_mail_address@gmail.com"
    password: "your_gmail_password"
cloudinary:
    cloud_name: your_cloud_name
    api_key: your_api_key
    api_secret: your_api_secret
    enhance_image_tag: true
    static_file_support: false
```

- CredentialsのKeyをHerokuに登録

```console
# Herokuに登録、heroku-cliをインストールしておく
$ heroku config:set RAILS_MASTER_KEY=$(cat config/credentials/production.key)
```

- HerokuにSakazukiをデプロイする
  - まだ

## How to develop with Docker

レポジトリをDocker Bindするため、レポジトリをWSLファイルシステムに置くと動きません。

- Dockerイメージのビルド

```console
$ docker-compose build
Building web
...
Successfully tagged sakazuki:latest
```

- PostgreSQLコンテナの初期設定

```console
$ docker-compose run --rm web bundle exec rails db:create
Creating network "sakazuki_default" with the default driver
...
Created database 'sakazuki_development'
Created database 'sakazuki_test'
$ docker-compose run --rm web bundle exec rails db:migrate
Creating sakazuki_web_run ... done
...
== 20210126072328 AddColumnToUsers: migrating =================================
-- add_column(:users, :confirmation_token, :string)
   -> 0.0070s
-- add_column(:users, :confirmed_at, :datetime)
   -> 0.0051s
-- add_column(:users, :confirmation_sent_at, :datetime)
   -> 0.0046s
-- add_column(:users, :unconfirmed_email, :string)
   -> 0.0040s
== 20210126072328 AddColumnToUsers: migrated (0.0225s) ========================

Model files unchanged.
$ docker-compose run --rm web bundle exec rails db:seed
Creating sakazuki_web_run ... done
```

- Dockerイメージの起動

```console
$ docker-compose up
sakazuki_db_1 is up-to-date
sakazuki_webdriver_1 is up-to-date
Creating sakazuki_web_1 ... done
...
```

- Sakazukiへのアクセス
  - 上記consoleを起動したままブラウザで<http://localhost:3000>へアクセスする

- Gem/Node Packageの更新があった場合は、`docker-compose build`でイメージを更新する

## How to Contribute

- GitHubのIssue/Pull Requestにて受けつけています
  - 現状では少数開発なので、受け入れるレベルは明確化されていません
- Pull RequestはGitHubActionsを通してください
  - 手動でチェックを走らせる場合は`cli-scripts/run-all-checks.sh`で実行できます
