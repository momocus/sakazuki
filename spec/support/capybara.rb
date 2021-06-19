require "capybara/rspec"

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_headless

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    # 基本はCapybara.default_driver
    # context, describe, itメソッドの引数にjs: true を設定したら、Capybara.javascript_driverを使う
    driven_by(Capybara.current_driver)
  end
end

# "data-testid"をCapybaraのclick_linkなどで使えるように、Optional attributeに登録する
Capybara.configure do |config|
  config.test_id = "data-testid"
end

# Capybaraのカスタムセレクタ
# find(:test_id, "email")でfind("[data-testid='email']")と同じく、data-testidが指定値のタグを取得できる
# 参考: https://speakerdeck.com/yasaichi/tokyurubykaigi12
Capybara.add_selector(:test_id) do
  css { |val| %([data-testid="#{val}"]) }
end

# ページ遷移を待つ
#
# Capybaraのfindはページロードを待つため、これを使えばもっと効率のよいwaitが実装できる。
# しかし、findでページ遷移をwaitするには、遷移前と遷移後で変化する要素が必要となる
# 任意のページ遷移で該当する要素が思いつかず、汎用関数にできていない。
def wait_for_page
  sleep(1)
  nil
end
