class AddCopiedFromToSakes < ActiveRecord::Migration[6.1]
  def change
    add_column :sakes, :copied_from, :integer, null: true, default: nil
  end
end
