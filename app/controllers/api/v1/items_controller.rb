class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.handle_pagination(params[:per_page], params[:page])
    render json: ItemSerializer.new(@items)
  end
end