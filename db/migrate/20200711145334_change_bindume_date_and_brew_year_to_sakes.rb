class ChangeBindumeDateAndBrewYearToSakes < ActiveRecord::Migration[6.0]
  def change
    change_column :sakes, :bindume_date, :date
    change_column :sakes, :brew_year, :date
  end
end
