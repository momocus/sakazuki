require "capybara/rspec"
require "selenium-webdriver"

Capybara.register_driver(:remote_firefox) do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  Capybara::Selenium::Driver.new(app, options:)
end

Capybara.javascript_driver = :remote_firefox
Capybara.default_driver = :rack_test

Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
# Capybara.server_port = 3001 # 指定しなければランダムなポートが割り当てられる
Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"

RSpec.configure do |config|
  config.before(:each, type: :system) do |_example|
    # 基本はCapybara.default_driver
    # context, describe, itメソッドの引数にjs: true を設定したら、Capybara.javascript_driverを使う
    driven_by(Capybara.current_driver)
  end
end

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
# @param page_path [String] ページのパス
def wait_for_page(page_path)
  find(:test_id, page_path, visible: false)
end

# alertが表示されるまで待つ
#
# ユーザーが現在いるページにリダイレクトされたとき、何らかのアラートが表示されるまで待つ。
def wait_for_alert
  find(:test_id, "flash_message")
end

# 酒のshowページのパスから、そのページで表示している酒オブジェクトを取得する
#
# @param url_path [String] "/sakes/1"のようなshowページのパス
# @return [Sake] 酒オブジェクト
def sake_from_show_path(url_path)
  path_pattern = %r{^/sakes/(\d+)$}
  result = path_pattern.match(url_path)
  result && Sake.find(result[1])
end
