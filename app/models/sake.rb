class Sake < ApplicationRecord
  enum bottle_state: [:sealed, :opened, :empty]
end
