module ApplicationHelper
  # rubocop:disable Metrics/MethodLength
  def seo_meta_tags
    set_meta_tags(
      icon: [
        {
          rel: "apple-touch-icon-precomposed",
          sizes: "180x180",
          href: asset_pack_path("media/images/apple-touch-icon.png"),
          type: "image/png",
        },
        {
          rel: "icon",
          sizes: "32x32",
          href: asset_pack_path("media/images/favicon-32x32.png"),
          type: "image/png",
        },
      ],
      site: "SAKAZUKI",
      title: "",
      separator: "-",
      reverse: true,
      description: t(".description"),
      og: {
        title: :title,
        url: request.original_url,
        type: "website",
        image: asset_pack_path("media/images/choko.svg"),
        description: :description,
      },
      twitter: { card: "summary" },
    )
    set_meta_tags(fb: { app_id: ENV["FB_APP_ID"] }) if ENV["FB_APP_ID"]
    display_meta_tags
  end

  # rubocop:enable Metrics/MethodLength

  # 読み込むJavascriptの指定
  #
  # @param packs [Array<String>] 読み込む.jsファイル名の配列
  def select_pack_js(packs)
    content_for(:pack_js) do
      javascript_pack_tag(*packs, "data-turbolinks-track": "reload")
    end
  end

  # 読み込むStylesheetの指定
  #
  # @param packs [Array<String>] 読み込む.scssファイル名の配列
  def select_pack_style(packs)
    content_for(:pack_style) do
      stylesheet_pack_tag(*packs, media: "all", "data-turbolinks-track": "reload")
    end
  end

  # Google AdSenseのscriptタグを書き出す
  #
  # Production環境の場合のみscriptタグを書き出す。
  # 引数のクライアントIDの方が.envファイルのクライアントIDよりも優先される。
  #
  # @param client [String] "ca-pub-12345"のようなGoogle AdSenseのクライアントID
  # @return [String] Google AdSense用のscriptタグ
  def adsense_tags(client = nil)
    return unless Rails.env.production?

    client ||= ENV["GOOGLE_ADSENSE_CLIENT"]
    src = "https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=#{client}"
    client ? tag.script(async: "async", src: src, crossorigin: "anonymous") : ""
  end
end
