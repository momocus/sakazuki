class RenameKouboColumnToSakes < ActiveRecord::Migration[6.0]
  def change
    rename_column :sakes, :koubo, :kobo
  end
end
