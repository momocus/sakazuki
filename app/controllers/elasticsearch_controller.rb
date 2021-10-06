class ElasticsearchController < ApplicationController
  def index
    if Sake.any?
      @sakes = Sake.simple_search(params.dig(:elasticsearch, :word))
        .page(params[:page])
        .results
    else
      @sakes = Sake.all.page
    end
  end
end
