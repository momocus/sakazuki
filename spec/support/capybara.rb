require "capybara/rspec"

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_headless

# ページ遷移を待つ
#
# Capybaraのfindはページロードを待つため、これを使えばもっと効率のよいwaitが実装できる。
# しかし、findでページ遷移をwaitするには、遷移前と遷移後で変化する要素が必要となる
# 任意のページ遷移で該当する要素が思いつかず、汎用関数にできていない。
def wait_for_page
  sleep(1)
  nil
end
