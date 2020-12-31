class ChangeDatatypeNihonshudoOfSakes < ActiveRecord::Migration[6.0]
  def change
    change_column :sakes, :nihonshudo, 'float USING CAST(nihonshudo AS float)'
  end
end
