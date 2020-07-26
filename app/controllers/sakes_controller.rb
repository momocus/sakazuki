class SakesController < ApplicationController
  before_action :set_sake, only: %i[show edit update destroy]
  before_action :signed_in_user, only: %i[new create edit update destroy]
  before_action :correct_user, only: :destroy

  # GET /sakes
  # GET /sakes.json
  def index
    @sakes =
      if signed_in?
        current_user.sakes.all
      else
        Sake.all
      end
  end

  # GET /sakes/1
  # GET /sakes/1.json
  def show
    @sakes = Sake.all
  end

  # GET /sakes/new
  def new
    @sake = Sake.new
  end

  # GET /sakes/1/edit
  def edit; end

  # POST /sakes
  # POST /sakes.json
  def create
    @sake = current_user.sakes.build(sake_params)
    respond_to do |format|
      if @sake.save
        format.html { redirect_to @sake, notice: "Create successfully." }
        format.json { render :show, status: :created, location: @sake }
      else
        format.html { render :new }
        format.json { render json: @sake.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sakes/1
  # PATCH/PUT /sakes/1.json
  def update
    respond_to do |format|
      if @sake.update(sake_params)
        format.html { redirect_to @sake, notice: "Update successfully." }
        format.json { render :show, status: :ok, location: @sake }
      else
        format.html { render :edit }
        format.json { render json: @sake.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sakes/1
  # DELETE /sakes/1.json
  def destroy
    @sake.destroy
    respond_to do |format|
      format.html { redirect_to sakes_url, notice: "Destroy successfully." }
      format.json { head :no_content }
    end
  end

  def filter
    filter_sake_params = params[:filter].present? ? filter_params : nil
    @sake = Search::Sake.new(filter_sake_params)
    @sakes = @sake.filter
    render :index
  end

  private

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
                  :tokutei_meisho, :genryoumai, :kakemai,
                  :kobo, :alcohol, :aminosando, :season,
                  :warimizu, :moto, :seimai_buai, :roka,
                  :shibori, :note, :bottle_level, :hiire,
                  :size, :price, :user_id)
  end

  def filter_params
    params.require(:filter).permit(:word, :only_in_stock, :user_id)
  end
end
