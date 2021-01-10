module ApplicationHelper
  def twitter_meta_tag
    tag.meta name: "twitter:card", content: "summary_large_image"
  end
end
