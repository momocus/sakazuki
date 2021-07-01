module Searchable
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [Rails.application.engine_name, Rails.env].join("_")
    sake_settings = YAML.load_file(Rails.root.join("config/elasticsearch.yml"))

    settings sake_settings do
      mapping do
        indexes :id, type: "integer"
        indexes :alcohol, type: "float"
        indexes :aminosando, type: "float"
        indexes :aroma_impression, analyzer: "ja"
        indexes :aroma_value, type: "integer"
        indexes :awa, analyzer: "ja"
        indexes :bindume_date, type: "date"
        indexes :bottle_level, analyzer: "ja"
        indexes :brew_year, type: "date"
        indexes :color, analyzer: "ja"
        indexes :genryomai, analyzer: "ja"
        indexes :hiire, analyzer: "ja"
        indexes :kakemai, analyzer: "ja"
        indexes :kobo, analyzer: "ja"
        indexes :kura, analyzer: "ja"
        indexes :moto, analyzer: "ja"
        indexes :name, analyzer: "ja"
        indexes :nigori, analyzer: "ja"
        indexes :nihonshudo, type: "float"
        indexes :note, analyzer: "ja"
        indexes :price, type: "integer"
        indexes :roka, analyzer: "ja"
        indexes :sando, type: "float"
        indexes :season, analyzer: "ja"
        indexes :seimai_buai, type: "integer"
        indexes :shibori, analyzer: "ja"
        indexes :size, type: "integer"
        indexes :taste_impression, analyzer: "ja"
        indexes :taste_value, type: "integer"
        indexes :todofuken, analyzer: "ja"
        indexes :tokutei_meisho, analyzer: "ja"
        indexes :warimizu, analyzer: "ja"
        indexes :created_at, type: "date"
        indexes :updated_at, type: "date"
      end
    end

    def as_indexed_json(_options = {})
      hash = as_json
      hash["tokutei_meisho"] = tokutei_meisho_i18n
      # enum値がunknownの時は検索したくないため空文字列にする
      hash["warimizu"] = warimizu == "unknown" ? "" : warimizu_i18n
      hash["moto"] = moto == "unknown" ? "" : moto_i18n
      hash["bottle_level"] = bottle_level_i18n
      hash["hiire"] = hiire == "unknown" ? "" : hiire_i18n
      hash
    end

    # rubocop:disable Metrics/MethodLength
    def self.simple_search(keyword)
      @search_definition = {
        query: { match_all: {} },
        post_filter: { bool: { must: [match_all: {}] } },
        sort: { updated_at: "desc" },
      }

      if keyword.present?
        @search_definition[:query] = {
          multi_match: {
            query: keyword,
            fields: %w[name kura todofuken aroma_impression color taste_impression nigori awa
                       tokutei_meisho genryomai kakemai kobo season warimizu moto roka shibori note bottle_level hiire],
            operator: "and",
          },
        }
      end
      __elasticsearch__.search(@search_definition)
    end
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Metrics/BlockLength
end
