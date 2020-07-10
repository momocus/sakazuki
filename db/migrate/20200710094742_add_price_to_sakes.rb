class AddPriceToSakes < ActiveRecord::Migration[6.0]
  def change
    add_column :sakes, :price, :integer
  end
end
