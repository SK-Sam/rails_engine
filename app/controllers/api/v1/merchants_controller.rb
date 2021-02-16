class Api::V1::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.handle_pagination(params[:per_page].to_i, params[:page].to_i)
    render json: MerchantSerializer.new(@merchants)
  end

  def show
    if !Merchant.exists?(params[:id])
      render json: {
        error: "No such merchant with ID #{params[:id]}"
      }, status: 404
    else
      @merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(@merchant)
    end
  end
end