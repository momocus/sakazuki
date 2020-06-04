class RemoveColumnsFromSakes < ActiveRecord::Migration[6.0]
  def change
    remove_column :sakes, :is_namadume, :boolean
    remove_column :sakes, :is_namacho, :boolean
  end
end
