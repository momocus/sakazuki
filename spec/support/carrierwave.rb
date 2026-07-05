# テストの画像アップロード先を削除する
RSpec.configure do |config|
  config.after(:suite) do
    if Rails.application.config.x.temp_uploads_dir_enabled
      temp_dir = Rails.application.config.x.uploads_dir
      FileUtils.rm_rf(Rails.public_path.join(temp_dir))
    end
  end
end
