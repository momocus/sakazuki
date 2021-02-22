require "capybara/rspec"

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_headless
if ENV["SELENIUM_REMOTE_HOST"]
  Capybara.javascript_driver = :selenium_remote_firefox
  Capybara.register_driver :selenium_remote_firefox do |app|
    url = "http:://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub"
    Capybara::Selenium::Driver.new(app,
                                   brouser: :remote,
                                   url: url,
                                   desired_capabilities: :firefox)
  end
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_headless
