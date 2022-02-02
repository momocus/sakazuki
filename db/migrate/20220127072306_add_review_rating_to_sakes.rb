class AddReviewRatingToSakes < ActiveRecord::Migration[6.1]
  def change
    add_column :sakes, :rating, :integer, null: false, default: 0
  end
end
