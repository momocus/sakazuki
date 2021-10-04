# frozen_string_literal: true

class AddOpenAndEmptyDaysToSakes < ActiveRecord::Migration[6.1]
  def up
    # updated_atの更新を一時的にオフにする
    ActiveRecord::Base.record_timestamps = false

    Sake.where(bottle_level: :empty).find_each do |sake|
      sake.update(opened_at: sake.created_at, emptied_at: sake.updated_at)
    end

    Sake.where(bottle_level: :opened).find_each do |sake|
      sake.update(opened_at: sake.updated_at)
    end

    ActiveRecord::Base.record_timestamps = true
  end

  def down
    # updated_atの更新を一時的にオフにする
    ActiveRecord::Base.record_timestamps = false

    Sake.update(opened_at: nil)
    Sake.update(emptied_at: nil)

    ActiveRecord::Base.record_timestamps = true
  end
end
