class RenameColumnsToSakes < ActiveRecord::Migration[6.0]
  def change
    rename_column :sakes, :product_of, :todouhuken
    rename_column :sakes, :bindume, :bindume_date
    rename_column :sakes, :by, :brew_year
    rename_column :sakes, :taste_int, :taste_value
    rename_column :sakes, :aroma_int, :aroma_value
    rename_column :sakes, :sake_metre_value, :nihonshudo
    rename_column :sakes, :acidity, :sando
    rename_column :sakes, :aroma_text, :aroma_impression
    rename_column :sakes, :taste_text, :taste_impression
    rename_column :sakes, :amino_acid, :aminosando
    rename_column :sakes, :aged, :season
    rename_column :sakes, :rice_polishing, :seimai_buai
    rename_column :sakes, :memo, :note
  end
end
