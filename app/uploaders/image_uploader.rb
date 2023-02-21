class ImageUploader < CarrierWave::Uploader::Base
  if Rails.env.production?
    include Cloudinary::CarrierWave
  else
    include CarrierWave::MiniMagick
    storage :file
  end

  if Rails.env.production?
    process(ocr: "adv_ocr:ja")
    process(convert: "webp")
  end

  version :thumb do
    # HACK: 1:1でスマホで２つ並んでも潰れないサイズ
    process(resize_to_fill: [600, 600]) if Rails.env.production?
  end

  version :large_twitter_card do
    if Rails.env.production?
      cloudinary_transformation(crop: :thumb, width: 600, height: 300, sign_url: true,
                                gravity: :ocr_text)
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end
end
