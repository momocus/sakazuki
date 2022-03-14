RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)
end

def sake_with_photos(photo_count: 3)
  FactoryBot.create(:sake) do |sake|
    image = Rack::Test::UploadedFile.new(Rails.root.join("spec/system/files/sake_photo1.jpg"))
    FactoryBot.create_list(:photo, photo_count, sake: sake, image: image)
  end
end
