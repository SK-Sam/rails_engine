class Api::V1::Merchants::RevenuesController < ApplicationController
  def most_revenue
    @merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(@merchants)
  end
end