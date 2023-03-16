RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)
end

def sake_with_photos(photo_count: 1, sake_options: {}, file_ext: "avif")
  FactoryBot.create(:sake, sake_options) do |sake|
    image = Rack::Test::UploadedFile.new(Rails.root.join("spec/system/files/sake_photo1.#{file_ext}"))
    FactoryBot.create_list(:photo, photo_count, sake:, image:)
  end
end
