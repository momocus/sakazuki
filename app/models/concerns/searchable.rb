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
        indexes :aroma_impression, analyzer: "ja"
        indexes :awa, analyzer: "ja"
        indexes :color, analyzer: "ja"
        indexes :genryomai, analyzer: "ja"
        indexes :kakemai, analyzer: "ja"
        indexes :kobo, analyzer: "ja"
        indexes :kura, analyzer: "ja"
        indexes :name, analyzer: "ja"
        indexes :nigori, analyzer: "ja"
        indexes :note, analyzer: "ja"
        indexes :roka, analyzer: "ja"
        indexes :season, analyzer: "ja"
        indexes :shibori, analyzer: "ja"
        indexes :taste_impression, analyzer: "ja"
        indexes :todofuken, analyzer: "ja"
      end
    end

    # rubocop:disable Metrics/MethodLength
    def as_indexed_json(_options = {})
      {
        aroma_impression: aroma_impression,
        awa: awa,
        color: color,
        genryomai: genryomai,
        kakemai: kakemai,
        kobo: kobo,
        kura: kura,
        name: name,
        nigori: nigori,
        note: note,
        roka: roka,
        season: season,
        shibori: shibori,
        taste_impression: taste_impression,
        todofuken: todofuken,
      }.as_json
    end
    # rubocop:enable Metrics/MethodLength

    def self.simple_search(keyword)
      __elasticsearch__.search(
        query: {
          multi_match: {
            query: keyword,
            fields: ["*"],
            operator: "and",
          },
        },
      )
    end
  end
  # rubocop:enable Metrics/BlockLength
end
