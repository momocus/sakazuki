class ChangeWarimizuToSakes < ActiveRecord::Migration[6.0]
  def change
    change_column :sakes, :warimizu, :integer
  end
end
