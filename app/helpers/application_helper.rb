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
        image: {
          _: "#{request.base_url}#{asset_pack_path("media/images/choko.png")}",
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
  # @param name [String] 読み込む.jsファイル名の配列
  def select_js(*name)
    content_for(:js) do
      javascript_include_tag(*name, "data-turbo-track": "reload", defer: true)
    end
  end

  # 読み込むStylesheetの指定
  #
  # @param packs [Array<String>] 読み込む.scssファイル名の配列
  def select_pack_style(packs)
    content_for(:pack_style) do
      stylesheet_pack_tag(*packs, media: "all")
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
