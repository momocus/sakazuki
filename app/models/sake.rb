class Sake < ApplicationRecord
  enum bottle_state: { sealed: 0, opened: 1, empty: 2 }
  enum hiire_state: { unknown: 0, namanama: 1, mae_hiire: 2,
                      ato_hiire: 3, nido_hiire: 4 }
  validates :name, presence: true
end
