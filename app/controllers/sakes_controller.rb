class SakesController < ApplicationController
  before_action :set_sake, only: %i[show edit update destroy]
  before_action :signed_in_user, only: %i[new create edit update destroy]

  include SakesHelper

  # GET /sakes
  # GET /sakes.json
  def index
    sort_key = empty_to_default(params[:sort], "id").intern
    sort_order = params[:order] == "asc" ? :asc : :desc
    @sakes = all_bottles(params[:all_bottles]).order(sort_key => sort_order)
  end

  # GET /sakes/1
  # GET /sakes/1.json
  def show; end

  def show_photo
    @photo = Photo.find(params[:photo_id])
  end

  # GET /sakes/new
  def new
    @sake = Sake.new
    @sake.brew_year = to_by(Time.zone.today)
  end

  # GET /sakes/1/edit
  def edit; end

  # POST /sakes
  # POST /sakes.json
  def create
    @sake = Sake.new(sake_params)

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

  def filter
    filter_sake_params = params[:filter].present? ? filter_params : nil
    @sake = Search::Sake.new(filter_sake_params)
    @sakes = @sake.filter
    render :index
  end

  private

  # flagがないときは、空瓶を除外したSakeモデルを取得して返す
  def all_bottles(flag)
    flag.blank? ? Sake.where.not(bottle_level: :empty) : Sake.all
  end

  def to_by(date)
    by_year = date.year - (date.month >= 7 ? 0 : 1)
    # BYは年のみ、使わない月日はBY始まりの7/1とする
    Date.new(by_year, 7)
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

  def filter_params
    params.require(:filter).permit(:word, :only_in_stock)
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
