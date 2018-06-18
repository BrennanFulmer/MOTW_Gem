
class Cli
  # attr_accessor

  def initialize
    Movie.create_from_collection(Scraper.scrape_list)
    display_list
  end

  def display_list
    Movie.all.each_with_index { |v, i|
      puts "
        #{v.title}"
      unless v.metascore == ''
        puts "  #{v.metascore} Metascore"
      end
      puts "#{v.description}
      "
    }
  end


end
