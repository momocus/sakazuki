class AddColumnToUsers < ActiveRecord::Migration[6.0]
  def change
      ## Confirmable
      add_column :users, :confirmation_token, :string
      add_column :users, :confirmed_at, :datetime
      add_column :users, :confirmation_sent_at, :datetime
      add_column :users, :unconfirmed_email,:string
  end
end
