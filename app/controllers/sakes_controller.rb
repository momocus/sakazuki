# rubocop:disable Metrics/ClassLength
class SakesController < ApplicationController
  before_action :set_sake, only: %i[show edit update destroy]
  after_action :update_datetime, only: %i[update]
  after_action :create_datetime, only: %i[create]
  before_action :signed_in_user, only: %i[new create edit update destroy]

  include SakesHelper

  # GET /sakes
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
  def show; end

  # GET /sakes/new
  def new
    copied_id = params[:copied_from]
    if copied_id
      copied = Sake.find(copied_id)
      attr = copy_attributes(copied)
      @sake = Sake.new(attr)
      flash[:info] = t(".copy", name: alert_link_tag(copied.name, sake_path(copied)))
    else
      @sake = Sake.new(default_attributes)
    end
  end

  # GET /sakes/1/edit
  def edit
    # 開けたボタン経由での処理
    @sake.bottle_level = params["sake"]["bottle_level"] if params.dig(:sake, :bottle_level)
  end

  # POST /sakes
  def create
    @sake = Sake.new(sake_params)

    if @sake.save
      store_photos
      msg = t(".success", name: alert_link_tag(@sake.name, sake_path(@sake)))
      redirect_to(@sake, status: :see_other, flash: { success: msg })
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /sakes/1
  def update
    if @sake.update(sake_params)
      delete_photos
      store_photos
      flash_after_update
      redirect_after_update
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /sakes/1
  def destroy
    deleted_name = @sake.name
    @sake.destroy
    redirect_to(sakes_url,
                status: :see_other,
                flash: { success: t(".success", name: deleted_name) })
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
    %w[alcohol aminosando bindume_on brewery_year genryomai hiire kakemai kobo
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

  # 新規酒のデフォルト情報をもったハッシュを作成する
  #
  # @return [Hash<Symbol => Integer, Date>] デフォルト酒情報のハッシュ
  def default_attributes
    {
      size: 720,
      brewery_year: to_by(Time.current),
      bindume_on: Time.current.to_date.beginning_of_month,
    }
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
    @sake.assign_attributes(opened_at: @sake.created_at) unless @sake.sealed?
    @sake.assign_attributes(emptied_at: @sake.created_at) if @sake.empty?
    @sake.save
  end

  # Only allow a list of trusted parameters through.
  def sake_params
    params.require(:sake)
          .permit(:name, :kura, :bindume_on, :brewery_year,
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
      redirect_to(@sake, status: :see_other)
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

    key = params[:flash_message_type] || "success"
    key = ".#{key}"
    name = alert_link_tag(@sake.name, sake_path(@sake))
    link = flash_review_link(@sake)
    # rubocop:disable Rails/ActionControllerFlashBeforeRender
    flash[:success] = t(key, name:, link:) # HACK: key: "open"のときのみlinkが使われ、他では無視される
    # rubocop:enable Rails/ActionControllerFlashBeforeRender
  end

  # flash内のレビューするリンクを作成する
  #
  # @param sake [Sake] レビュー対象の酒オブジェクト
  # @return [String] レビューリンク
  def flash_review_link(sake)
    # レビュー項目に注目し、アコーディオンを開く
    href = edit_sake_path(sake, review: true, anchor: "headingReview")
    review = view_context.tag.i(class: "bi-chat-square-heart me-1", style: "font-size: 0.98em;") + t(".review")
    alert_link_tag(review, href)
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
