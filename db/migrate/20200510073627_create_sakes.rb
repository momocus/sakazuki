class CreateSakes < ActiveRecord::Migration[6.0]
  def change
    create_table :sakes do |t|
      t.string :name
      t.string :kura
      t.binary :photo
      t.datetime :touroku
      t.datetime :bindume
      t.datetime :by
      t.string :product_of
      t.integer :taste_int
      t.integer :aroma_int
      t.integer :sake_metre_value
      t.integer :acidity
      t.text :aroma_text
      t.string :color
      t.text :taste_text
      t.boolean :is_namadume
      t.boolean :is_namacho
      t.string :nigori
      t.string :awa
      t.integer :tokutei_meisho
      t.string :genryoumai
      t.string :kakemai
      t.string :koubo
      t.integer :alcohol
      t.integer :amino_acid
      t.string :aged
      t.integer :warimizu
      t.integer :moto
      t.integer :rice_polishing
      t.string :roka
      t.string :shibori
      t.text :memo

      t.timestamps
    end
  end
end
