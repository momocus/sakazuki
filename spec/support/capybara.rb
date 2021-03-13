require "capybara/rspec"

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_headless

def wait_for_page
  # MEMO:
  # findなどを使って実装しようとしたが諦めた。
  # Capybaraはfindが失敗すると自動でページ遷移を待つ機能がある。
  # よって、findでページ遷移を待つためには、
  # 遷移前と遷移後で変化する要素を指定する必要がある。
  # しかし、すべてのページ遷移で変化する要素が思いつかず、汎用関数にできなかった。
  sleep(1)
  nil
end
