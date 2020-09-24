module SakesHelper
  # HACK: 整数値と文字列値のどちらでも使えるようにnil/blankで判定している
  def empty_to_default(value, default = "-")
    value.nil? || value.blank? ? default : value
  end
end
