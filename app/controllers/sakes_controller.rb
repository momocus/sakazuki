# rubocop:disable Metrics/ClassLength
class SakesController < ApplicationController
  before_action :set_sake, only: %i[show edit update destroy]
  after_action :update_datetime, only: %i[update]
  after_action :create_datetime, only: %i[create]
  before_action :signed_in_user, only: %i[new create edit update destroy]

  include SakesHelper

  # GET /sakes
  # GET /sakes.json
  # rubocop:disable Metrics/AbcSize
  def index
    query = params[:q] ? params[:q].deep_dup : {} # avoid nil

    # default, not empty bottle
    query.merge!({ bottle_level_not_eq: Sake.bottle_levels["empty"] }) unless include_empty?(query)

    # multiple words search
    to_multi_search!(query) if query[:all_text_cont]

    # Ransack search and sort
    @search = Sake.ransack(query)
    @search.sorts = ["bottle_level", "id desc"]
    @sakes = @search.result.includes(:photos)

    # Kaminari pager
    @sakes = @sakes.page(params[:page]) if include_empty?(query)
  end

  # rubocop:enable Metrics/AbcSize

  # GET /sakes/1
  # GET /sakes/1.json
  def show; end

  # GET /sakes/new
  def new
    copied_id = params[:copied_from]
    if copied_id
      copied = Sake.find(copied_id)
      flash[:info] = t(".copy", name: alert_link_tag(copied.name, sake_path(copied_id)))
      attr = copy_attributes(copied)
      @sake = Sake.new(attr)
    else
      @sake = Sake.new(size: 720, brew_year: to_by(Time.current))
    end
  end

  # GET /sakes/1/edit
  def edit
    # 開けたボタン経由での処理
    @sake.bottle_level = params["sake"]["bottle_level"] if params.dig(:sake, :bottle_level)
  end

  # POST /sakes
  # POST /sakes.json
  # rubocop:disable Metrics/MethodLength
  def create
    @sake = Sake.new(sake_params)

    respond_to do |format|
      if @sake.save
        store_photos
        format.html {
          redirect_to(@sake)
          flash[:success] = t(".success", name: alert_link_tag(@sake.name, sake_path(@sake)))
        }
      else
        format.html { render(:new, status: :unprocessable_entity) }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /sakes/1
  # PATCH/PUT /sakes/1.json
  # rubocop:disable Metrics/MethodLength
  def update
    respond_to do |format|
      if @sake.update(sake_params)
        delete_photos
        store_photos
        format.html {
          redirect_after_update
          flash_after_update
        }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # DELETE /sakes/1
  # DELETE /sakes/1.json
  def destroy
    deleted_name = @sake.name
    @sake.destroy
    respond_to do |format|
      format.html {
        redirect_to(sakes_url)
        flash[:success] = t(".success", name: deleted_name)
      }
    end
  end

  # Viewで使える用に宣言する
  helper_method :include_empty?
  # 空き瓶を表示するかどうかを調べる
  #
  # @param query [Hash<Symbol => String] params[:q]に格納されたRansackのクエリ
  # @return [Boolean] 空き瓶も込みで表示するならtrueを返す
  def include_empty?(query)
    !query.nil? and query[:bottle_level_not_eq] == bottom_bottle.to_s
  end

  # GET /sakes
  def menu
    @sakes = Sake.ransack(bottle_level_not_eq: Sake.bottle_levels["empty"], s: "id desc").result
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

  # コピー機能の対象キーかどうか
  #
  # @param key [Symbol] 酒カラム
  # @return [Boolean] コピー対象のキーならtrue
  def copy_key?(key)
    %w[alcohol aminosando bindume_date brew_year genryomai hiire kakemai kobo
       kura moto name nihonshudo price roka sando season seimai_buai shibori
       size todofuken tokutei_meisho warimizu].include?(key)
  end

  # コピーする酒情報を持ったハッシュを作成する
  #
  # @param sake [Sake] コピーする対象の酒オブジェクト
  # @return [Hash<Symbol => String, Integer, Date>] コピーする酒情報のハッシュ
  def copy_attributes(sake)
    all = sake.attributes
    all.select { |key, _v| copy_key?(key) }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sake
    @sake = Sake.includes(:photos).find(params[:id])
  end

  # 酒瓶状態の変更に応じて、酒が持つ日時データを更新する
  def update_datetime
    case @sake.saved_change_to_attribute(:bottle_level)
    in [old, new]
      @sake.assign_attributes(opened_at: @sake.updated_at) if old == "sealed"
      @sake.assign_attributes(emptied_at: @sake.updated_at) if new == "empty"
    in nil
      nil
    end
    @sake.save
  end

  # 作成された酒の瓶状態に応じて、酒が持つ日時データを更新する
  def create_datetime
    @sake.assign_attributes(opened_at: @sake.created_at) unless @sake.bottle_level == "sealed"
    @sake.assign_attributes(emptied_at: @sake.created_at) if @sake.bottle_level == "empty"
    @sake.save
  end

  # Only allow a list of trusted parameters through.
  def sake_params
    params.require(:sake)
          .permit(:name, :kura, :bindume_date, :brew_year,
                  :todofuken, :taste_value, :aroma_value,
                  :nihonshudo, :sando, :aroma_impression,
                  :color, :taste_impression, :nigori, :awa,
                  :tokutei_meisho, :genryomai, :kakemai,
                  :kobo, :alcohol, :aminosando, :season,
                  :warimizu, :moto, :seimai_buai, :roka,
                  :shibori, :note, :bottle_level, :hiire,
                  :size, :price, :rating)
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

  # update後のリダイレクト処理
  #
  # 編集画面からupdateする場合、詳細ページにリダイレクトする。
  # HTTP_REFERERが設定されていない場合、詳細ページにリダイレクトする。
  # 上記のどちらにも当てはまらない場合、ユーザーが直前にいたページにリダイレクトする。
  def redirect_after_update
    if update_from_edit?
      redirect_to(@sake)
    else
      redirect_back(fallback_location: @sake)
    end
  end

  # @return [Boolean] 編集画面からUpdateが行われたらtrueを返す
  def update_from_edit?
    request.referer&.match?(%r{/sakes/[0-9]+/edit})
  end

  # update後のフラッシュメッセージ表示
  #
  # 開封するボタン・空にするボタンからupdateした場合は、専用のフラッシュメッセージを表示する
  def flash_after_update
    return unless @sake.saved_changes?

    message_key = case params[:flash_message_type]
                  when "open"
                    ".success_open"
                  when "empty"
                    ".success_empty"
                  else
                    ".success"
                  end
    flash[:success] = t(message_key, name: alert_link_tag(@sake.name, sake_path(@sake)))
  end

  # flashメッセージ内に表示するリンクを生成する
  # @example
  #   alert_link_tag("text","path/to/somewhere") #=> "<a class="alert-link" href="path/to/somewhere">text</a>"
  # @param text [String] 表示するテキスト
  # @param path [String] リンクするパス
  # @return [String] アンカーリンク
  def alert_link_tag(text, path)
    view_context.link_to(text, path, { class: "alert-link" })
  end
end

# rubocop:enable Metrics/ClassLength
