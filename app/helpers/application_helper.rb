module ApplicationHelper
  # rubocop:disable Metrics/MethodLength
  def seo_meta_tags
    set_meta_tags(icon: [
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
                  ])
    display_meta_tags(site: "SAKAZUKI",
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
                      fb: { app_id: ENV["FB_APP_ID"] })
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
end
