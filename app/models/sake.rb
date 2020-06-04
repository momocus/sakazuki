class Sake < ApplicationRecord
  enum bottle_state: [:sealed, :opened, :empty]
  enum hiire_state: [:unknown, :namanama, :mae_hiire, :ato_hiire, :nido_hiire]
  validates :name, presence: true
end
