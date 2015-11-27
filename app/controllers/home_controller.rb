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

  def add_email
    if params_permited[:email] =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      result = Mailchimp.new(settings.mailchimp_key, settings.mailchimp_list_name).add_subscriber params_permited[:email]
      return "You add to newsletter" if result
      "Sorry something goes wrong plz try later"
    else
      "Its not looks like email :("
    end
  end

  private
  def params_permited
    params.permit(:email)
  end
end
