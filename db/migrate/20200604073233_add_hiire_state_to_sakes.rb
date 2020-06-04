class AddHiireStateToSakes < ActiveRecord::Migration[6.0]
  def change
    add_column :sakes, :hiire_state, :integer
  end
end
