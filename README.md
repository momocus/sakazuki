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
- 複数人での在庫の共有
- PC・スマホ対応のレスポンシブデザイン
- 画像は AVIF 形式に圧縮して [Cloudinary](https://cloudinary.com/) にアップロード

## Watch a demo

- [SAKAZUKI](https://sakazuki.fly.dev/)

## Requirements

- Ruby = (See .ruby-version file)
- Bundler
- Yarn🐈 >= 1.22.4
- Node.js >= 12.20.1
- PostgreSQL >= 12.0
- ImageMagick >= 6.9

## Setup

- 依存関係のインストール
  - `bundle install`
  - `yarn install`
- .env ファイルの作成
  - PostgreSQL の設定
  - Google AdSense のクライアント ID の設定（Google AdSense を使う場合）

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

- DB の作成
  - `bundle exec rails db:create`
  - `bundle exec rails db:migrate`
  - `bundle exec rake parallel:setup`、並列テストを使う場合
- 管理者ユーザの作成
  - `bundle exec rails db:seed`
- サーバの起動
  - `bundle exec rails server`
- SAKAZUKI へのアクセス
  - <http://localhost:3000/>にアクセス
  - デフォルトか前項内容でログイン
    - デフォルトメールアドレス: `example@example.com`
    - デフォルトパスワード: `rootroot`


Development 環境において、メール通知は <http://localhost:3000/letter_opener> で確認します。

## How to deploy

See the [deployment](https://github.com/momocus/sakazuki/wiki/Deployment).

## Setup on Docker

- Docker イメージのビルド

```console
$ docker compose build --build-arg RUBY_VERSION=$(cat .ruby-version)
...
```

- PostgreSQL コンテナの初期設定

<!-- markdownlint-disable MD013 -->

```console
$ docker compose run --rm web bundle exec rails db:create
Creating volume "sakazuki_db_storage" with local driver
Creating sakazuki_db_1 ... done
Creating sakazuki_web_run ... done
Created database 'sakazuki_development'
Created database 'sakazuki_test'
$ docker compose run --rm web bundle exec rake parallel:setup
...
$ docker compose run --rm web bundle exec rails db:migrate
Creating sakazuki_web_run ... done
...
Model files unchanged.
$ docker compose run --rm web bundle exec rails db:seed
Creating sakazuki_web_run ... done
```

<!-- markdownlint-enable MD013 -->

- Docker イメージの起動

```console
$ docker compose up
...
```

- Gem/Node Package の更新があった場合は、`docker compose build`でイメージを更新する

- 起動している Docker コンテナでテストを実行する

```console
$ docker compose exec web bundle exec rspec
...
```

## Special Thanks

- 筆によるすてきな SAKAZUKI by 豆腐屋さん
