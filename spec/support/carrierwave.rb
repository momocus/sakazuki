# テスト中のアップロード先をpublic/uploadsからtmp以下に変更する
# トランザクションのロールバックではCarrierWaveのファイル削除コールバックが動かないため、
# public以下に保存するとテスト後にファイルが残り続ける
CarrierWave.configure do |config|
  config.root = Rails.root.join("tmp/carrierwave#{ENV.fetch('TEST_ENV_NUMBER', '')}")
end

RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf(CarrierWave::Uploader::Base.root)
  end
end
