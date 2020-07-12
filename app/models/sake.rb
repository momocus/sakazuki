class Sake < ApplicationRecord
  enum bottle_level: {
    sealed: 0,
    opened: 1,
    empty: 2,
  }
  enum hiire: {
    unknown: 0,
    namanama: 1,
    mae_hiire: 2,
    ato_hiire: 3,
    nido_hiire: 4,
  }, _prefix: true
  enum tokutei_meisho: {
    none: 0,
    honjozo: 1,
    ginjo: 2,
    daiginjo: 3,
    junmai: 4,
    junmai_ginjo: 5,
    junmai_daiginjo: 6,
    tokubetsu_honjozo: 7,
    tokubetsu_junmai: 8,
  }, _prefix: true
  enum moto: {
    unknown: 0,
    kimoto: 1,
    yamahai: 2,
    sokujo: 3,
  }, _prefix: true
  enum warimizu: {
    unknown: 0,
    kasui: 1,
    genshu: 2,
  }, _prefix: true
  validates :name, presence: true
end
