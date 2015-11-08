class Mailchimp
  def initialize api_key, list_name
    @gibbon = Gibbon::Request.new(api_key: api_key)
    @list_id = @gibbon.lists.retrieve["lists"].select { |item| item["name"] == list_name  }.first["id"]
  end

  def add_subscriber email
    @gibbon.lists(@list_id).members.create(body: { email_address: email, status: "subscribed" })
  rescue Exception => e
  end
end
