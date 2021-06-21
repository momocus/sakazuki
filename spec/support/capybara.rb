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
# Capybaraでselenium driverなどを使うと、テスト処理にページ遷移が追いつかずテストが落ちることがある。
# このメソッドでページ遷移を待つことができる。
# 対象ページにはdata-testidに自身のパスを持つことを想定している。
#
# @example index.htmlの場合
#   wait_for_page(sakes_path)
#
# @param [String] page_path ページのパス
def wait_for_page(page_path)
  find(:test_id, page_path, visible: false)
end
