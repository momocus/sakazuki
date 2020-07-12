class ChangeColumnDefaultToSakes < ActiveRecord::Migration[6.0]
  def change
    change_column_default :sakes, :hiire, from: nil, to: 0
    change_column_default :sakes, :tokutei_meisho, from: nil, to: 0
    change_column_default :sakes, :moto, from: nil, to: 0
    change_column_default :sakes, :warimizu, from: nil, to: 0
  end
end
