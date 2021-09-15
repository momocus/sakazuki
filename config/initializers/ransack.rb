Ransack.configure do |c|
  # Raise errors if a query contains an unknown predicate or attribute.
  # Default is true (do not raise error on unknown conditions).
  c.ignore_unknown_conditions = false

  # ソート時NULL値を一番小さな数値として扱う
  # TODO: Ransackのバージョンが上がったら:nulls_always_last（常に最後）を採用する
  c.postgres_fields_sort_option = :nulls_first
  # c.postgres_fields_sort_option = :nulls_always_last

  # ソート時のアイコン設定
  c.custom_arrows = {
    up_arrow: '<i class="bi-sort-down"></i>',
    down_arrow: '<i class="bi-sort-down-alt"></i>',
  }
end
