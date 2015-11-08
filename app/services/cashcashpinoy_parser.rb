class CashcashpinoyParser < ParserBase
  ITEMS_URL = 'http://www.cashcashpinoy.com/rest/category/1/deals'
  BASE_IMAGE_URL = 'http://cdn3.cashcashpinoy.com/upload/deals/'

  def retrieve
    response = conn.get ITEMS_URL
    response.body
  end

  def transform data
    hash = JSON.parse data, symbolize_names: true

    hash[:objects].map do |item|
      {
        datasource: 'cashcashpinoy',
        title: title(item),
        deal_url:  link(item),
        image_url: image(item),
        currency:  '₱',
        deal_price: parse_number(item[:price]),
        original_price: parse_number(item[:original_price]),
        discount: parse_number(item[:discount]),
        description: item[:description],
        deal_end: item[:ends_at]
      }
    end
  end

  def link item
    deal_type = nil
    deal_type = "/d" if item[:deal_type] == "2"
    line = "#{item[:category_id]} #{category_name(item)}#{deal_type}/#{item[:reference_id]} #{item[:title]}"
    line = line.downcase.strip.gsub(/\s/, "-")
    "http://www.cashcashpinoy.com/#!/#{line}"
  end

  def image item
    "http://cdn3.cashcashpinoy.com/upload/deals/#{item[:image_m]}"
  end

  def title item
    unless item[:title]
      [:title_m, :title_b, :title_s].each do |key|
        break item[:title] = item[key] if item[key]
      end
    end
    item[:title] = filter item[:title]
  end

  def category_name item
    filter item[:category_name]
  end

  def filter line
    [
      {"&" => "and"}, {"'" => ""}, {"," => ""},
      {"!" => ""}, {"+" => ""}, {"." => ""},
      {"é" => ""}, {"/" => ""}
    ].each do |hash|
      line = line.gsub(hash.first[0], hash.first[1])
    end
    line
  end

end
