class AddBottleStateToSakes < ActiveRecord::Migration[6.0]
  def change
    add_column :sakes, :bottle_state, :integer, default: 0
  end
end
