class RenameStateColumnsToSakes < ActiveRecord::Migration[6.0]
  def change
    rename_column :sakes, :hiire_state, :hiire
    rename_column :sakes, :bottle_state, :bottle_level
    rename_column :sakes, :is_genshu, :warimizu
  end
end
