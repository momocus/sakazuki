module ApplicationHelper
  def twitter_meta_tags
    display_meta_tags(
      twitter: { card: "summary" },
      og: { title: "Sakazuki" },
    )
  end
end
