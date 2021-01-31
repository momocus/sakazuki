module Searchable
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join("_")

    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mapping do
        indexes :aroma_impression, analyzer: "kuromoji"
        indexes :awa, analyzer: "kuromoji"
        indexes :color, analyzer: "kuromoji"
        indexes :genryomai, analyzer: "kuromoji"
        indexes :kakemai, analyzer: "kuromoji"
        indexes :kobo, analyzer: "kuromoji"
        indexes :kura, analyzer: "kuromoji"
        indexes :name, analyzer: "kuromoji"
        indexes :nigori, analyzer: "kuromoji"
        indexes :note, analyzer: "kuromoji"
        indexes :roka, analyzer: "kuromoji"
        indexes :season, analyzer: "kuromoji"
        indexes :shibori, analyzer: "kuromoji"
        indexes :taste_impression, analyzer: "kuromoji"
        indexes :todofuken, analyzer: "kuromoji"
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def as_indexed_json(_options = {})
      {
        name: name,
        kura: kura,
        todofuken: todofuken,
        aroma_impression: aroma_impression,
        color: color,
        taste_impression: taste_impression,
        nigori: nigori,
        awa: awa,
        tokutei_meisho: tokutei_meisho_i18n,
        genryomai: genryomai,
        kakemai: kakemai,
        kobo: kobo,
        season: season,
        warimizu: warimizu_i18n,
        moto: moto_i18n,
        roka: roka,
        shibori: shibori,
        note: note,
        hiire: hiire_i18n,
      }.as_json
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
  # rubocop:enable Metrics/BlockLength
end
