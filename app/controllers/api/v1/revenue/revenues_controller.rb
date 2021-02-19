class Api::V1::Revenue::RevenuesController < ApplicationController
  def most_revenue
    @merchants = Merchant.most_revenue(params[:quantity])
    render json: {
      error: "Quantity greater than 0 required"
    }, status: 400 if @merchants == "Error"
    render json: MerchantNameRevenueSerializer.new(@merchants)
  end

  def merchant_revenue
    @merchant = Merchant.merchant_revenue(params[:merchant_id])
    render json: MerchantRevenueSerializer.new(@merchant)
  end

  def invoices_unshipped
    @invoices = Invoice.get_unshipped_revenues(params[:quantity])
    render json: UnshippedOrderSerializer.new(@invoices)
  end
end