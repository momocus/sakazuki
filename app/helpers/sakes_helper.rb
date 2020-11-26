module SakesHelper
  # HACK: 整数値と文字列値のどちらでも使えるようにnil/blankで判定している
  def empty_to_default(value, default = "-")
    value.nil? || value.blank? ? default : value
  end

  # cl_image_tagメソッドはCloudinaryと連携した状態でないと動かないため、
  # 本番環境とテスト環境で、画像表示のメソッドを切り替える
  def wrap_image_tag(*args)
    if Rails.env.production?
      cl_image_tag(*args)
    else
      image_tag(*args)
    end
  end
end
