class ChangeAminosandAndAlcoholAndSandoToSakes < ActiveRecord::Migration[6.0]
  def change
    change_column :sakes, :aminosando, :float
    change_column :sakes, :alcohol, :float
    change_column :sakes, :sando, :float
  end
end
