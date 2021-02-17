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
    @item = Item.new(
      name: params[:item][:name],
      description: params[:item][:description],
      unit_price: params[:item][:unit_price],
      name: params[:item][:name],
      merchant_id: merchant.id
    )
    @item.save
  end

end