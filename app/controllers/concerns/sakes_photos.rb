# Sake画像に関する機能を提供するモジュール
module SakesPhotos
  extend ActiveSupport::Concern

  # 画像を保存する
  def store_photos
    photos = sake_params[:photos]
    photos&.each { |photo| @sake.photos.create(image: photo) }
  end

  # チェックボックスで選択された画像を削除する
  def delete_photos
    @sake.photos.each do |photo|
      photo.destroy! if params[photo.chackbox_name] == "delete"
    end
  end
end
