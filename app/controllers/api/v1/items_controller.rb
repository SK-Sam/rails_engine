class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.handle_pagination(params[:per_page].to_i, params[:page].to_i)
    render json: ItemSerializer.new(@items)
  end
end