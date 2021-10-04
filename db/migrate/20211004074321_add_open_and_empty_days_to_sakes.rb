class AddOpenAndEmptyDaysToSakes < ActiveRecord::Migration[6.1]
  def change
    add_column :sakes, :opened_at, :datetime, precision: 6
    add_column :sakes, :emptied_at, :datetime, precision: 6
  end
end
