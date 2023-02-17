class ImageUploader < CarrierWave::Uploader::Base
  if Rails.env.production?
    include Cloudinary::CarrierWave
  else
    include CarrierWave::MiniMagick
    storage :file
  end

  process(ocr: "adv_ocr:ja") if Rails.env.production?
  process(convert: "webp")

  version :thumb do
    # HACK: 1:1でスマホで２つ並んでも潰れないサイズ
    process(resize_to_fill: [600, 600])
  end

  version :large_twitter_card do
    if Rails.env.production?
      cloudinary_transformation(crop: :thumb, width: 600, height: 300, sign_url: true, gravity: :ocr_text)
    else
      process(resize_to_fill: [600, 300])
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{super.chomp(File.extname(super))}.webp" if original_filename.present?
  end

  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end
end
