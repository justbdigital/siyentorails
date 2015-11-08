class SuredealParser
  attr_accessor :gdeals, :tdeals, :mdeals
  
  def fetch
    #Suredeal Groupon Variables
    gurl = "http://suredeal.com.ph/manila/all-deals/beeconomic/?order=cheapest-deals"
    gdata = Nokogiri::HTML(open(gurl))
    @gdeals = gdata.css('.deal-container-large')

    #Suredeal Tcat Variables
    turl = "http://suredeal.com.ph/manila/shopping-and-product-deals/tcat/?order=cheapest-deals"
    tdata = Nokogiri::HTML(open(turl))
    @tdeals = tdata.css('.deal-container-large')

    #Suredeal Metro Deals Variables
    murl = "http://suredeal.com.ph/manila/all-deals/metrodeal/?order=cheapest-deals"
    mdata = Nokogiri::HTML(open(murl))
    @mdeals = mdata.css('.deal-container-large')
  end
end
