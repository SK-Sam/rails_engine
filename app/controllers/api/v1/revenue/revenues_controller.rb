class Api::V1::Revenue::RevenuesController < ApplicationController
  def most_revenue
    @merchants = Merchant.most_revenue(params[:quantity])
    if @merchants == "Error" || params[:quantity] == nil
      render json: {error: "Quantity greater than 0 required"}, status: 400 #if @merchants == "Error" || params[:quantity] == nil
    else
      render json: MerchantNameRevenueSerializer.new(@merchants)
    end
  end

  def merchant_revenue
    if !Merchant.exists?(params[:merchant_id])
      render json: {error: "No merchant exists"}, status: 404
    else
      @merchant = Merchant.merchant_revenue(params[:merchant_id])
      render json: MerchantRevenueSerializer.new(@merchant)
    end
  end

  def invoices_unshipped
    @invoices = Invoice.get_unshipped_revenues(params[:quantity])
     render json: {
       error: "Quantity greater than 0 required"
     }, status: 400 if @merchants == "Error"
    render json: UnshippedOrderSerializer.new(@invoices)
  end
end