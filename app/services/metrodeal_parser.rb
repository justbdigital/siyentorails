class MetrodealParser < ParserBase
  ITEMS_URL = 'http://www.metrodeal.com/web_api/?request=loadDeals&page=%s&category_id=0&by_category=false'

  def retrieve
    data = []
    5.times do |time|
      url = ITEMS_URL % (time + 1)
      response = conn.get url, [], 'http://www.metrodeal.com/category/All',  { 'Accept' => 'application/json', 'X-Requested-With' => 'XMLHttpRequest' }
      data << JSON.parse(response.body, symbolize_names: true)
    end
    data
  end

  def transform inputs
    inputs.flat_map do |input|
      input[:deals].map do |item|
        {
          datasource: 'metrodeal',
          deal_url:  item[:link],
          image_url: item[:image],
          currency:  '₱',
          deal_price: parse_number(item[:price]),
          original_price: parse_number(item[:value]),
          discount: parse_number(item[:discount]),
          purchases: item[:sold_count].to_i,
          title: item[:title]
        }
      end
    end
  end
end
