# flashを画面上部のアラートで表示するためヘルパーモジュール
module FlashHelper
  # flashをどのbootstrapアラートタイプで表示するか
  #
  # RailsやDevise生成のnotice/alertにも対応している。
  #
  # @param key [String, Symbol] flashハッシュのキー
  # @return [String] どのアラートタイプを使うかを文字列で返す
  def flash_type(key)
    FLASH_TYPES[key.to_sym] || "light"
  end

  # flashメッセージの表示内容を生成する
  #
  # @param key [Symbol, String] flashのキー
  # @param value [Hash, String] 必要に応じて、酒の名前やidを持つハッシュ、または、表示するメッセージそのもの
  # @return [String] 表示するメッセージ
  def flash_message(key, value) # rubocop:disable Metrics/MethodLength
    t_key = flash_t_key(key)
    message =
      case key.to_sym
      when :copy_sake, :create_sake, :update_sake, :empty_sake
        t(t_key, name: sake_link(value))
      when :open_sake
        name = sake_link(value)
        link = sake_review_link(value)
        t(t_key, name:, link:)
      when :delete_sake
        t(t_key, name: value)
      else # RailsやDevise生成のnotice/alert
        value
      end
    sanitize(message, tags: %w[a i], attributes: %w[class href style])
  end

  # 残念ながらprivateにしてもviewからは見える
  # 読みやすさのために書いておく
  private

  # @type [Hash{Symbol, String}]
  FLASH_TYPES = {
    copy_sake: "info",
    notice: "success",
    create_sake: "success",
    update_sake: "success",
    empty_sake: "success",
    delete_sake: "success",
    open_sake: "success",
    alert: "danger",
  }.freeze
  private_constant :FLASH_TYPES

  # flashのキーからI18n翻訳に使うキーを生成する
  #
  # @param key [String] flashハッシュのキー
  # @return [String] `I18n.t`の引数
  def flash_t_key(key)
    "helper.flash.#{key}"
  end

  # flashメッセージに表示する、酒詳細リンクを持った酒の名前を生成する
  #
  # @example
  #   sake_link({ name: "ほしいずみ", id: 3 })
  #     #=> "<a class="alert-link" href="/sakes/3">ほしいずみ</a>"
  # @param sake [Hash] 酒の名前とidを持つハッシュ
  # @return [String] 酒へのリンク
  def sake_link(sake)
    # HACK: flash経由でキーがStringに変換されることがあるため対処
    link = sake_path(sake[:id] || sake["id"])
    name = sake[:name] || sake["name"]
    link_to(name, link, { class: "alert-link" })
  end

  # flashメッセージにおける、レビューするリンクを作成する
  #
  # @param sake [Hash] 酒のidを持つハッシュ
  # @return [String] レビューリンク
  def sake_review_link(sake)
    text = tag.i(class: "bi-chat-square-heart me-1", style: "font-size: 0.98em;") + t("helper.flash.review")
    # HACK: flash経由でキーがStringに変換されることがあるため対処
    id = sake[:id] || sake["id"]
    # レビュー項目に注目しアコーディオンを開くリンク
    link = edit_sake_path(id, review: true, anchor: "headingReview")
    link_to(text, link, { class: "alert-link" })
  end
end
