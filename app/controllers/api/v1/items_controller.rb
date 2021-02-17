class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.handle_pagination(params[:per_page].to_i, params[:page].to_i)
    render json: ItemSerializer.new(@items)
  end

  def show
    @item = Item.find(params[:id])
    render json: ItemSerializer.new(@item)
  end

  def create
    merchant = Merchant.find(params[:item][:merchant_id])
    @item = Item.new(book_params)
    @item.save
    render json: ItemSerializer.new(@item), status: :created
  end

  private

  def book_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end