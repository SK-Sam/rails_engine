class Api::V1::Merchants::RevenuesController < ApplicationController
  def most_revenue
    @merchants = Merchant.most_revenue(params[:quantity])
    render json: {
      error: "Quantity greater than 0 required"
    }, status: 400 if @merchants == "Error"
    render json: MerchantNameRevenueSerializer.new(@merchants)
  end
end