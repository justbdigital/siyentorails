class ParserBase

  def initialize
    @conn = Mechanize.new do |agent|
      agent.user_agent_alias =  'Windows Mozilla'
    end
  end

  def fetch
    transform retrieve
  end

  def conn
    @conn
  end

  def parse_number input
    return 0 unless input
    input = input.gsub ",", ""
    input.scan(/\d+/).first.to_i
  end
end
