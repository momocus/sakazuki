class CreateSakes < ActiveRecord::Migration[6.0]
  def change
    create_table :sakes do |t|
      t.string :name
      t.string :kura
      t.binary :photo
      t.date :bindume_date
      t.date :brew_year
      t.string :todofuken
      t.integer :taste_value
      t.integer :aroma_value
      t.integer :nihonshudo
      t.float :sando
      t.text :aroma_impression
      t.string :color
      t.text :taste_impression
      t.string :nigori
      t.string :awa
      t.integer :tokutei_meisho, default: 0
      t.string :genryomai
      t.string :kakemai
      t.string :kobo
      t.float :alcohol
      t.float :aminosando
      t.string :season
      t.integer :warimizu, default: 0
      t.integer :moto, default: 0
      t.integer :seimai_buai
      t.string :roka
      t.string :shibori
      t.text :note
      t.integer :bottle_level, default: 0
      t.integer :hiire, default: 0
      t.integer :price
      t.integer :size

      t.timestamps
    end
  end
end
