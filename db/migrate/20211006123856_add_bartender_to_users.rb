class AddBartenderToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :bartender, :boolean, default: false, null: false
  end
end
