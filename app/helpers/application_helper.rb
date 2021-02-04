module ApplicationHelper
  def twitter_meta_tags
    display_meta_tags(twitter: { card: "summary" },
                      og: { title: "Sakazuki" })
  end

  def bi_icon(icon, options = {})
    path = asset_path("bootstrap-icons/bootstrap-icons.svg")
    options = { class: "bi", fill: "currentColor" }.merge(options) { |_, default, added| "#{default} #{added}" }
    tag.svg(tag.use(nil, "xlink:href" => "#{path}##{icon}"), options)
  end
end
