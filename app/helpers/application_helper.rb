module ApplicationHelper
  # サイトデフォルト設定のメタタグのハッシュを取得する
  #
  # @return [Hash] meta_tagsで利用できるハッシュ
  # rubocop:disable Metrics/MethodLength
  def default_meta_tags
    {
      icon: [
        {
          rel: "apple-touch-icon-precomposed",
          sizes: "180x180",
          href: asset_path("apple-touch-icon.png"),
          type: "image/png",
        },
        {
          rel: "icon",
          sizes: "32x32",
          href: asset_path("favicon-32x32.png"),
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
        image: {
          _: image_url("choko.png"),
          width: 600,
          height: 600,
        },
        description: :description,
      },
      twitter: {
        card: "summary",
      },
    }
  end

  # rubocop:enable Metrics/MethodLength

  # 読み込むJavascriptの指定
  #
  # @param name [String] 読み込む.jsファイル名、複数記述できる
  def select_js(*name)
    content_for(:js) do
      javascript_include_tag(*name, "data-turbo-track": "reload", defer: true)
    end
  end

  # 読み込むStylesheetの指定
  #
  # @param name [String] 読み込む.scssファイル名、複数記述できる
  def select_css(*name)
    content_for(:css) do
      stylesheet_link_tag(*name, "data-turbo-track": "reload")
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
