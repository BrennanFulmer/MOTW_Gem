class Scraper
  attr_accessor :doc

  def initialize
    self.doc = Nokogiri::HTML(open("https://www.rottentomatoes.com/browse/opening/"))
  end

end
