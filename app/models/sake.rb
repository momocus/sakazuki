# == Schema Information
#
# Table name: sakes
#
#  id               :bigint           not null, primary key
#  alcohol          :float
#  aminosando       :float
#  aroma_impression :text
#  aroma_value      :integer
#  awa              :string
#  bindume_date     :date
#  bottle_level     :integer          default("sealed")
#  brew_year        :date
#  color            :string
#  genryomai        :string
#  hiire            :integer          default("unknown")
#  kakemai          :string
#  kobo             :string
#  kura             :string
#  moto             :integer          default("unknown")
#  name             :string
#  nigori           :string
#  nihonshudo       :float
#  note             :text
#  price            :integer
#  roka             :string
#  sando            :float
#  season           :string
#  seimai_buai      :integer
#  shibori          :string
#  size             :integer
#  taste_impression :text
#  taste_value      :integer
#  todofuken        :string
#  tokutei_meisho   :integer          default("none")
#  warimizu         :integer          default("unknown")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require "elasticsearch/model"

class Sake < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :photos, dependent: :destroy
  enum bottle_level: {
    sealed: 0,
    opened: 1,
    empty: 2,
  }
  enum hiire: {
    unknown: 0,
    namanama: 1,
    mae_hiire: 2,
    ato_hiire: 3,
    nido_hiire: 4,
  }, _prefix: true
  enum tokutei_meisho: {
    none: 0,
    honjozo: 1,
    ginjo: 2,
    daiginjo: 3,
    junmai: 4,
    junmai_ginjo: 5,
    junmai_daiginjo: 6,
    tokubetsu_honjozo: 7,
    tokubetsu_junmai: 8,
  }, _prefix: true
  enum moto: {
    unknown: 0,
    kimoto: 1,
    yamahai: 2,
    sokujo: 3,
  }, _prefix: true
  enum warimizu: {
    unknown: 0,
    kasui: 1,
    genshu: 2,
  }, _prefix: true

  validates :name, presence: true
  validates :kura, exclusion: { in: [nil] }
  # validates :photo
  # validates :bindume_date,
  # validates :brew_year,
  validates :todofuken, exclusion: { in: [nil] }
  validates :taste_value,
            numericality: {
              allow_nil: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 6,
            }
  validates :aroma_value,
            numericality: {
              allow_nil: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 6,
            }
  validates :nihonshudo, numericality: { allow_nil: true }
  validates :sando, numericality: { allow_nil: true }
  validates :aroma_impression, exclusion: { in: [nil] }
  validates :color, exclusion: { in: [nil] }
  validates :taste_impression, exclusion: { in: [nil] }
  validates :nigori, exclusion: { in: [nil] }
  validates :awa, exclusion: { in: [nil] }
  validates :tokutei_meisho, presence: true
  validates :genryomai, exclusion: { in: [nil] }
  validates :kakemai, exclusion: { in: [nil] }
  validates :kobo, exclusion: { in: [nil] }
  validates :alcohol, numericality: { allow_nil: true }
  validates :aminosando, numericality: { allow_nil: true }
  validates :season, exclusion: { in: [nil] }
  validates :warimizu, presence: true
  validates :moto, exclusion: { in: [nil] }
  validates :seimai_buai, numericality: { allow_nil: true }
  validates :roka, exclusion: { in: [nil] }
  validates :shibori, exclusion: { in: [nil] }
  validates :note, exclusion: { in: [nil] }
  validates :bottle_level, presence: true
  validates :hiire, presence: true
  validates :price, numericality: { allow_nil: true }
  validates :size, numericality: true

  # rubocop:disable Layout/LineLength
  ransack_alias :all_text, :aroma_impression_or_awa_or_color_or_genryomai_or_kakemai_or_kobo_or_kura_or_name_or_nigori_or_note_or_roka_or_season_or_shibori_or_taste_impression_or_todofuken
  # rubocop:enable Layout/LineLength
end
