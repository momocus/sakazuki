# Sakazuki

自宅の酒を管理するアプリケーション

# Requirements

- Ruby >= 2.7.1
- Rails >= 6.0.3.2
- Yarn🐈 >= 1.22.4

# How to use

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
```ruby
# db/seed.rb
User.create!(
  email: "your_email_address@example.com",
  password: "your_password",
  admin: true,
)
```
- localユーザの設定
    - まだ

# How to Contribute

- まだ
