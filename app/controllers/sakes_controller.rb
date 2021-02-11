# rubocop:disable Metrics/ClassLength
class SakesController < ApplicationController
  before_action :set_sake, only: %i[show edit update destroy]
  before_action :signed_in_user, only: %i[new create edit update destroy]

  include SakesHelper

  # GET /sakes
  # GET /sakes.json
  # rubocop:disable Metrics/AbcSize
  def index
    # avoid nil
    params[:q] = {} unless params[:q]

    # default, not empty bottle
    params[:q].merge!({ bottle_level_not_eq: Sake.bottle_levels["empty"] }) unless params.dig(:q, :bottle_level_not_eq)

    # default, sort by id
    params[:q].merge!({ s: "id desc" }) unless params.dig(:q, :s)

    # search
    query = params[:q].deep_dup
    to_multi_search!(query) if query[:all_text_cont]
    @searched = Sake.ransack(query)
    @sakes = @searched.result(distinct: true).page(params[:page])
  end
  # rubocop:enable Metrics/AbcSize

  # GET /sakes/1
  # GET /sakes/1.json
  def show
    set_twitter_meta_tags
  end

  def show_photo
    @photo = Photo.find(params[:photo_id])
  end

  # GET /sakes/new
  def new
    @sake = Sake.new
    # デフォルト値を設定する
    @sake.brew_year = to_by(Time.zone.today)
    @sake.size = 720
  end

  # GET /sakes/1/edit
  def edit
    @sake.kura = add_todofuken(@sake.kura, @sake.todofuken)
  end

  # POST /sakes
  # POST /sakes.json
  def create
    @sake = Sake.new(sake_params)
    @sake.kura = strip_todofuken(@sake.kura)

    respond_to do |format|
      if @sake.save
        store_photos
        format.html { redirect_to @sake, notice: "Create successfully." }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /sakes/1
  # PATCH/PUT /sakes/1.json
  def update
    # sake_paramsを変更してもデータは変わらない
    params["sake"]["kura"] = strip_todofuken(params["sake"]["kura"])

    respond_to do |format|
      if @sake.update(sake_params)
        delete_photos
        store_photos
        format.html { redirect_to @sake, notice: "Update successfully." }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /sakes/1
  # DELETE /sakes/1.json
  def destroy
    @sake.destroy
    respond_to do |format|
      format.html { redirect_to sakes_url, notice: "Destroy successfully." }
    end
  end

  # GET /sakes/elasticsearch
  def elasticsearch
    @sakes = Sake.simple_search(params.dig(:elasticsearch, :word)).records
    # HACK: indexビュー表示にエラーが出ないようにするため、ransack用のインスタンス変数をセット
    @searched = Sake.ransack(nil)
    render :index
  end

  private

  def to_multi_search!(query)
    words = query.delete(:all_text_cont)
    query[:groupings] = separate_words(words)
  end

  def separate_words(words)
    # 全角空白または半角空白で区切ることを許可
    # { :name_cont => "" }があり得るがransackがSQL変換で削除するのでOK
    words.split(/[ 　]/).map { |word| { all_text_cont: word } }
  end

  # DBの蔵名に（県名）をつけて_formの描画でつかう形にする
  def add_todofuken(kura, todofuken)
    "#{kura}（#{todofuken}）"
  end

  # _formでの蔵名（県名）から県名を取り除いてDBへ保存する形にする
  def strip_todofuken(kura)
    kura.gsub(/（.*）/, "")
  end

  def set_twitter_meta_tags
    set_meta_tags(og: { title: "Sakazuki - #{@sake.name}" })
    set_meta_tags(og: { image: @sake.photos.first.image.thumb.url }) if @sake.photos.any?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sake
    @sake = Sake.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sake_params
    params.require(:sake)
          .permit(:name, :kura, :photo, :bindume_date, :brew_year,
                  :todofuken, :taste_value, :aroma_value,
                  :nihonshudo, :sando, :aroma_impression,
                  :color, :taste_impression, :nigori, :awa,
                  :tokutei_meisho, :genryomai, :kakemai,
                  :kobo, :alcohol, :aminosando, :season,
                  :warimizu, :moto, :seimai_buai, :roka,
                  :shibori, :note, :bottle_level, :hiire,
                  :size, :price)
  end

  def store_photos
    photos = params[:sake][:photos]
    photos&.each { |photo| @sake.photos.create(image: photo) }
  end

  def delete_photos
    @sake.photos.each do |photo|
      photo.destroy if params[photo.chackbox_name] == "delete"
    end
  end
end
# rubocop:enable Metrics/ClassLength
