class Sake < ApplicationRecord
  enum bottle_state: {
    sealed: 0,
    opened: 1,
    empty: 2,
  }
  enum hiire_state: {
    unknown: 0,
    namanama: 1,
    mae_hiire: 2,
    ato_hiire: 3,
    nido_hiire: 4,
  }
  enum tokutei_meisho: {
    nothing: 0,
    honjozo: 1,
    ginjo: 2,
    daiginjo: 3,
    junmai: 4,
    junmai_ginjo: 5,
    junmai_daiginjo: 6,
    tokubetsu_honjozo: 7,
    tokubetsu_junmai: 8,
  }
  validates :name, presence: true
end
