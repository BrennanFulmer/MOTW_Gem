
class Cli
  # attr_accessor

  def initialize
    Movie.create_from_collection(Scraper.scrape_list)
  end


end
