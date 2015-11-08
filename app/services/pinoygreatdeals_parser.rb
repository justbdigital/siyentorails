class PinoygreatdealsParser < ParserBase
  ITEMS_URL = "http://pinoygreatdeals.com/"

  def retrieve
    response = conn.get ITEMS_URL
    response.body
  end

  def transform data
    doc = Nokogiri::HTML(data)
    items = doc.css ".allDealItem"
    items.map do |item|
      parse item
    end
  end

  def parse item
    image_url = item.css("span.image img")[0].attributes["src"].value
    deal_price = parse_number(item.css(".amount span.price")[0].text)
    original_price = parse_number(item.css(".amount span.value")[0].text)
    discount = parse_number(item.css("span.discount")[0].text)
    {
      datasource: 'pinoygreatdeals',
      deal_url:  deal_url(item),
      image_url: image_url,
      currency:  '₱',
      deal_price: deal_price,
      original_price: original_price,
      discount: discount,
      title: title(item)
    }
  end

  def deal_url item
    url = item.css("a:nth-child(1)")[0].attributes["href"].value
    "http://pinoygreatdeals.com/#{url}"
  end

  def title item
    text = item.css("span.name")[0].text
    text = text.gsub /\s+for P[,\d]+/, ""
    text = text.gsub /\((Original Value|Value):\s?P[,\d]+\)/, ""
    text = text.gsub /\(P[,\d]+\ Value\)/, ""
    text = text.gsub /\s?P[,\d]+/, ""
    text.gsub /\s+/, " "
    text.strip
  end
end
