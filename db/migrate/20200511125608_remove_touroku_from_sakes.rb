class RemoveTourokuFromSakes < ActiveRecord::Migration[6.0]
  def change
    remove_column :sakes, :touroku, :datetime
  end
end
