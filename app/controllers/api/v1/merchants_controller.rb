class Api::V1::MerchantsController < ApplicationController

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