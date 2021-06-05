json.extract! sake,
  :id, :alcohol, :aminosando, :aroma_impression, :aroma_value,
  :awa, :bindume_date, :bottle_level, :brew_year, :color,
  :genryomai, :hiire, :kakemai, :kobo, :kura, :moto, :name,
  :nigori, :nihonshudo, :note, :price, :roka, :sando, :season,
  :seimai_buai, :shibori, :size, :taste_impression, :taste_value,
  :todofuken, :tokutei_meisho, :warimizu, :created_at, :updated_at
json.url sake_url(sake, format: :json)
