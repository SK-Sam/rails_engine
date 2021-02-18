class Api::V1::Items::SearchController < ApplicationController
  def find_all
    min_price = params[:min_price]
    max_price = params[:max_price]
    name = params[:name]
    @item = Item.find_by_args(min_price, max_price, name)
    render json: ItemSerializer.new(@item)
  end
end