class ElasticsearchController < ApplicationController
  def index
    @sakes = if Sake.any?
               Sake.simple_search(params.dig(:elasticsearch, :word)).page(params[:page]).results
             else
               Sake.all.page
             end
  end
end
