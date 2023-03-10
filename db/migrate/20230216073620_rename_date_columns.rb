class RenameDateColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column(:sakes, :bindume_date, :bindume_on)
    rename_column(:sakes, :brew_year, :brewery_year)
  end
end
