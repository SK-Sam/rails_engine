class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.handle_pagination(params[:per_page].to_i, params[:page].to_i)
    render json: ItemSerializer.new(@items)
  end

  def show
    @item = Item.find(params[:id])
    render json: ItemSerializer.new(@item)
  end

end