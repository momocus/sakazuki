class ElasticsearchController < ApplicationController
  def index
    @sakes = Sake.simple_search(params.dig(:elasticsearch, :word))
                 .page(params[:page])
                 .results
  end
end
