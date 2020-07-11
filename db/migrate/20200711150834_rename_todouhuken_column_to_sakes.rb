class RenameTodouhukenColumnToSakes < ActiveRecord::Migration[6.0]
  def change
    rename_column :sakes, :todouhuken, :todofuken
  end
end
