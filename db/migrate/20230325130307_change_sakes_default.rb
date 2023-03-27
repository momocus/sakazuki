class ChangeSakesDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:sakes, :size, from: nil, to: 720)
    change_column_default(:sakes, :opened_at, from: Time.zone.local(2021), to: nil)
    change_column_default(:sakes, :emptied_at, from: Time.zone.local(2021), to: nil)
  end
end
