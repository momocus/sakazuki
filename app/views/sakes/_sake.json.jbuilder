json.extract! sake, :id, :name, :kura, :photo, :touroku, :bindume, :by,
              :product_of, :taste_int, :aroma_int, :sake_metre_value, :acidity,
              :aroma_text, :color, :taste_text, :is_namadume, :is_namacho,
              :nigori, :awa, :tokutei_meisho, :genryoumai, :kakemai, :koubo,
              :alcohol, :amino_acid, :aged, :is_genshu, :moto, :rice_polishing,
              :roka, :shibori, :memo, :created_at, :updated_at
json.url sake_url(sake, format: :json)
