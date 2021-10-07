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
end
