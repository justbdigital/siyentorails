class TrendsndealsParser < ParserBase
  ITEMS_URL = "http://www.trendsndeals.com/?p=%s"

  def retrieve
    return data = []
    10.times do |time|
      response = conn.get ITEMS_URL % (time + 1)
      data << response.body
    end
    data
  end

  def transform data
    return data
    data.flat_map do |item|
      process item
    end
  end

  def process data
    doc = Nokogiri::HTML data
    items = doc.css ".item"
    items.map do |item|
      parse item
    end
  end

  def parse item
    image_url = item.css(".product-image-box a img")[0].attributes["src"].value
    deal_url = item.css(".product-image-box a")[0].attributes["href"].value
    deal_price = parse_number(item.css(".box-item.special-price span")[0].text)
    original_price =  parse_number(item.css(".box-item.old-price span")[0].text)
    title = parse_title item
    discount = parse_number(parse_discount item)
    {
      datasource: 'trendsndeals',
      deal_url:  deal_url,
      image_url: image_url,
      currency:  '₱',
      deal_price: deal_price,
      original_price: original_price,
      discount: discount,
      title: title
    }
  end

  private

  def parse_title item
    item.css(".product-name")[0].text.gsub /\s+\(.*/, ""
  end

  def parse_discount item
    item.css(".product-name")[0].text.scan(/\(.*?\)/)[0]
  end
end
