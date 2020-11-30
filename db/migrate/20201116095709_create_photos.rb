class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.integer :sake_id

      t.timestamps
    end
  end
end
