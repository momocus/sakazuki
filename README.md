# Sakazuki

![Generic Checks](https://github.com/momocus/sakazuki/workflows/Generic%20Checks/badge.svg)
![Checks by Node packages](https://github.com/momocus/sakazuki/workflows/Checks%20by%20Node%20packages/badge.svg)
![Checks by Gems](https://github.com/momocus/sakazuki/workflows/Checks%20by%20Gems/badge.svg)
![Check Dockerfile](https://github.com/momocus/sakazuki/workflows/Check%20Dockerfile/badge.svg)

自宅の酒を管理するアプリケーション

## Requirements

- Ruby = 2.7.2
- Bundler
- Yarn🐈 >= 1.22.4
- Node.js >= 12.20.1
- PostgreSQL >= 12.0
- ElasticSearch >= 7.10.2
  - [Japanese (kuromoji) Analysis Plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-kuromoji.html)

## How to use

- 依存関係のインストール
  - `bundle install`
  - `yarn install --check-files`
- PostgreSQLのユーザの設定
  - PostgreSQLへの接続に使われる

```shell
# .envファイルに記載 or 環境変数に設定
POSTGRES_USERNAME=your_postgresql_name
POSTGRES_PASSWORD=your_postgresql_password
```

- 最初のユーザの設定
  - `bundle exec rails db:seed`
- サーバの起動
  - `bundle exec rails server`
- ElasticSearchへデータをインポート
  - `bundle exec rake environment elasticsearch:import:model CLASS='Sake'`
- [http://localhost:3000/] へアクセスする
- 最初の管理者ユーザの設定（オプション）
  - Sakazukiへのログインに使われる

```ruby
# db/seed.rb
User.create!(
  email: "<your emacs address>",      # この2行を
  password: "your account password>", # 編集する
  admin: true,
  confirmed_at: Time.current,
)
```

- ログイン
  - メールアドレス: `example@example.com`
  - パスワード: `rootroot`
  - または前項で書き換えた内容でログイン
- localユーザの設定
  - まだ
- 送信メールの確認
  - [http://localhost:3000/letter_opener]にアクセス

## How to deploy to heroku

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

## How to develop with Docker

レポジトリをDocker Bindするため、レポジトリをWSLファイルシステムに置くと動きません。

- Dockerイメージのビルド

```console
$ docker-compose build
...
```

- PostgreSQLコンテナの初期設定

```console
$ docker-compose run --rm web bundle exec rails db:create
...
$ docker-compose run --rm web bundle exec rails db:migrate
...
$ docker-compose run --rm web bundle exec rails db:seed
...
```

- Dockerイメージの起動

```console
$ docker-compose up
...
```

- Gem/Node Packageの更新があった場合は、`docker-compose build`でイメージを更新する

## How to Contribute

- GitHubのIssue/Pull Requestにて受けつけています
  - 現状では少数開発なので、受け入れるレベルは明確化されていません
- Pull RequestはGitHubActionsを通してください
  - 手動でチェックを走らせる場合は`cli-scripts/run-all-checks.sh`で実行できます
