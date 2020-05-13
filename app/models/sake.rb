class Sake < ApplicationRecord
  enum bottle_state: [:sealed, :opened, :empty]
  validates :name, presence: true
end
