class HomeController < ApplicationController
  def index
    @offers = Offer.last_days.where("deal_price <= ?", 100)
    @index = 0
  end

  def filter
    @offers = Offer.last_days.where("deal_price <= ?", params[:deal_price])
    @index = 0
    render partial: "offers"
  end
end
