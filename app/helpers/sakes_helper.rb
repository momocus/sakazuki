module SakesHelper
  def empty_to_default(value, default)
    # HACK: IntegerとStringのどちらでも使えるようにnil/blankで判定している
    value.nil? || value.blank? ? default : value
  end
end
