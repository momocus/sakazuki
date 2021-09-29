module ApplicationHelper
  def seo_meta_tags
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
end
