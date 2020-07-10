class ChangeColumnsToSakes < ActiveRecord::Migration[6.0]
  def change
    change_column :sakes, :tokutei_meisho, :integer # 0:なし、1:本醸造、2:吟醸など
    change_column :sakes, :moto, :integer # 0: 不明、1:生酛, 2: 速醸酛など
  end
end
