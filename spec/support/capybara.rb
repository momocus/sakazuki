require "capybara/rails"
require "capybara/rspec"
require "selenium-webdriver"

Capybara.default_driver = :rack_test

if ENV["REMOTE_DRIVER_HOST"]
  Capybara.app_host = ENV.fetch("CAPYBARA_APP_HOST", nil)
  Capybara.server_host = ENV.fetch("CAPYBARA_SERVER_HOST", nil)
  Capybara.register_driver(:remote_firefox_headless) do |app|
    host = ENV["REMOTE_DRIVER_HOST"]
    port = ENV.fetch("REMOTE_DRIVER_PORT", 4444)
    url = "http://#{host}:#{port}/wd/hub"
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument("-headless")
    Capybara::Selenium::Driver.new(app, browser: :remote, options:, url:)
  end
  Capybara.javascript_driver = :remote_firefox_headless
else
  Capybara.javascript_driver = :selenium_headless
end

RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    # context/describe/itの`js: true`でdriverを切り替える
    driver = example.metadata[:js] ? Capybara.javascript_driver : Capybara.default_driver
    driven_by(driver)
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
