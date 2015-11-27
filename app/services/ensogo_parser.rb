class EnsogoParser < ParserBase
  ITEMS_URL = "http://www.ensogo.com.ph/"

  def retrieve
    response = conn.get ITEMS_URL
    response.body
  end

  def transform data
    doc = Nokogiri::HTML(data)
    items = doc.css '.small-block'
    items.map { |item| parse item }
  end

  def parse item
    image_url = item.css(".img-holder img")[0].attributes["data-original"].value
    deal_url = item.css('a')[0].attributes["href"].value
    deal_price = parse_number(item.css('.desc .currency')[0].children[1].text)
    original_price =  fetch_orginal_price item, deal_price
    title = item.css('.desc .title').text
    discount = parse_number item.css('.discount-indicate').text
    {
      datasource: 'ensogo',
      deal_url:  deal_url,
      image_url: image_url,
      currency:  '₱',
      deal_price: deal_price,
      original_price: original_price,
      discount: discount,
      title: title
    }
  end

  def fetch_orginal_price item, default
    return default unless item.css('.desc .currency')[1]
    parse_number(item.css('.desc .currency')[1].children[1].text)
  end
end
