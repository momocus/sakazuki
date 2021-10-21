class AddOpenAndEmptyDaysToSakes < ActiveRecord::Migration[6.1]
  def change
    add_column :sakes, :opened_at, :datetime, precision: 6, default: -> { "NOW()" }, null: false
    add_column :sakes, :emptied_at, :datetime, precision: 6, default: -> { "NOW()" }, null: false

    # updated_atの更新を一時的にオフにする
    ActiveRecord::Base.record_timestamps = false

    Sake.find_each do |sake|
      sake.update(opened_at: sake.created_at, emptied_at: sake.created_at)
    end

    Sake.where(bottle_level: :opened).find_each do |sake|
      sake.update(opened_at: sake.updated_at)
    end

    Sake.where(bottle_level: :empty).find_each do |sake|
      sake.update(emptied_at: sake.updated_at)
    end

    ActiveRecord::Base.record_timestamps = true
  end
end
