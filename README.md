# SAKAZUKI

![Check](https://github.com/momocus/sakazuki/workflows/Check/badge.svg)
![Test](https://github.com/momocus/sakazuki/workflows/Test/badge.svg)

自宅の酒を管理するアプリケーション

![Screenshot](./screenshot.png)

## What is SAKAZUKI?

- 日本酒の在庫を登録・開封・空で管理
- スペックや味わいを定量値・定性値で保存
- 在庫や過去に飲んだ日本酒を全文検索
- 在庫量と総飲酒量の表示

## Requirements

- Ruby = 3.0.2
- Bundler
- Yarn🐈 >= 1.22.4
- Node.js >= 12.20.1
- PostgreSQL >= 12.0
- ElasticSearch >= 7.10.2
  - Japanese (kuromoji) Analysis Plugin
  - ICU Analysis Plugin
- ImageMagick >= 6.9

## How to use

- 依存関係のインストール
  - `bundle install`
  - `yarn install`
- PostgreSQLのユーザの設定
  - PostgreSQLへの接続に使われる

```console
cp dotenv.example .env
```

```shell
# .env
POSTGRES_USERNAME=[YOUR POSTGRESQL NAME]
POSTGRES_PASSWORD=[YOUR POSTGRESQL PASSWORD]
```

- 管理者ユーザの設定（オプション）

```ruby
# db/seed.rb
User.create!(
  email: "[YOUR EMAIL ADDRESS]",
  password: "[YOUR ACCOUNT PASSWORD]",
  admin: true,
  confirmed_at: Time.current,
)
```

- 管理者ユーザの作成
  - `bundle exec rails db:seed`
- サーバの起動
  - `bundle exec rails server`
- SAKAZUKIへのログイン
  - <http://localhost:3000/>へアクセスする
  - メールアドレス: `example@example.com`
  - パスワード: `rootroot`
  - または前項で書き換えた内容でログイン
- localユーザの設定
  - まだ

### How to recieve EMail from SAKAZUKI in development environment

SAKAZUKIにてユーザのパスワードリセットはメールで通知される。
Development環境では、letter_openerを使ってメールを確認する。

- <http://localhost:3000/letter_opener>にアクセス

## How to deploy to Heroku

SAKAZUKIはHerokuで動かせる。
SAKAZUKIの画像はCloudinaryにアップロードされるため、Herokuで使うにはメールとCloudinaryの設定が必要。
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
    user_name: "[YOUR MAIL ADDRESS]@gmail.com"
    password: "[YOUR MAIL PASSWORD]"
cloudinary:
    cloud_name: [YOUR CLOUD NAME]
    api_key: [YOUR API KEY]
    api_secret: [YOUR API SECRET]
    enhance_image_tag: true
    static_file_support: false
```

- CredentialsのKeyをHerokuに登録

```console
# Herokuに登録、heroku-cliをインストールしておく
$ heroku config:set RAILS_MASTER_KEY=$(cat config/credentials/production.key)
```

- HerokuにSAKAZUKIをデプロイする
  - まだ

## How to develop with Docker

レポジトリをDocker Bindするため、レポジトリをWSLファイルシステムに置くと動きません。

- Dockerイメージのビルド

```console
$ docker-compose build
...
```

- PostgreSQLコンテナ、ElasticSearchコンテナの初期設定

```console
$ docker-compose run --rm web bundle exec rails db:create
...
$ docker-compose run --rm web bundle exec rails db:migrate
...
$ docker-compose run --rm web bundle exec rails db:seed
...
$ docker-compose run --rm es elasticsearch-plugin install analysis-icu
Creating sakazuki_es_run ... done
-> Installing analysis-icu
-> Downloading analysis-icu from elastic
[=================================================] 100%??
-> Installed analysis-icu
$ docker-compose run --rm es elasticsearch-plugin install analysis-kuromoji
Creating sakazuki_es_run ... done
-> Installing analysis-kuromoji
-> Downloading analysis-kuromoji from elastic
[=================================================] 100%??
-> Installed analysis-kuromoji
$ docker-compose run --rm web bundle exec rake environment \
  elasticsearch:import:model CLASS='Sake' FORCE=y
Creating sakazuki_web_run ... done
[IMPORT] Done
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
- Pull RequestはGitHub Actionsを通してください
  - 手動でチェックを走らせる場合は`cli-scripts/run-all-checks.sh`で実行できます
