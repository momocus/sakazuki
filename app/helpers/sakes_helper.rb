module SakesHelper
  def empty_to_default(value, default)
    value.presence || default
  end
end
