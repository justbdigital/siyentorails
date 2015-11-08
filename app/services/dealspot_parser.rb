class DealspotParser < ParserBase
  ITEMS_URL = "https://www.dealspot.ph/"
  ITEMS_URL_OTHER = "https://www.dealspot.ph/index.php/ds1/jscrollInfin/%s"


  def retrieve
    data = []
    response = conn.get ITEMS_URL
    data << response.body
    5.times do |time|
      response = conn.get ITEMS_URL_OTHER % (time + 1)
      data << response.body
    end
    data
  end

  def transform data
    first = true
    data.flat_map do |item|
      if first
        first = false
        process_first item
      else
        process_other item
      end
    end
  end

  def process_first item
    doc = Nokogiri::HTML(item)
    items = doc.css "table#tblInfinitScrollappend tr td[style^='padding']"
    items.map do |item|
      parse_first item
    end
  end

  def parse_first item
    image_url = item.css(".divProdDispBox_picarea img")[0].attributes["src"].value
    deal_url = item.css("a")[0].attributes["href"].value
    deal_price = parse_number(item.css(".divProdDispBox_sellingpricedisp")[0].text)
    original_price =  parse_number(item.css("strike")[0].text)
    title = item.css(".divProdDispBox_itemnamearea")[0].text.strip
    discount = parse_number(item.css(".divProdDispBox_discountdisp")[0].children[0].text)
    {
      datasource: 'dealspot',
      deal_url:  deal_url,
      image_url: image_url,
      currency:  '₱',
      deal_price: deal_price,
      original_price: original_price,
      discount: discount,
      title: title
    }
  end

  def process_other item
    doc = Nokogiri::HTML(item)
    items = doc.css "tr td[style^='padding']"
    items.map do |item|
      parse_other item
    end
  end

  def parse_other item
    image_url = item.css(".divProdDispBox_picarea img")[0].attributes["src"].value
    deal_url = item.css("a")[0].attributes["href"].value
    deal_price = parse_number(item.css(".divProdDispBox_sellingpricedisp")[0].text)
    original_price =  parse_number(item.css("strike")[0].text)
    title = item.css(".divProdDispBox_itemnamearea")[0].text.strip
    discount = parse_number(item.css(".divProdDispBox_discountdisp")[0].children[0].text)
    {
      datasource: 'dealspot',
      deal_url:  deal_url,
      image_url: image_url,
      currency:  '₱',
      deal_price: deal_price,
      original_price: original_price,
      discount: discount,
      title: title
    }
  end
end
