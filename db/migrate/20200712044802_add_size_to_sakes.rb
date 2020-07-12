class AddSizeToSakes < ActiveRecord::Migration[6.0]
  def change
    add_column :sakes, :size, :integer
  end
end
