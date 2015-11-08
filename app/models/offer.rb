class Offer < ActiveRecord::Base
  def self.last_days from=Date.today - 3
    if ActiveRecord::Base.connection.adapter_name == "SQLite"
      from = from.to_time
    end
    Offer.where("created_at > ?", from)
  end
end
