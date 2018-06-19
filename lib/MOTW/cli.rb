
class Cli
  attr_accessor :input

# greets, and calls methods
  def initialize
    puts 'Welcome to Movies Opening this Week'
    menu
  end

  def menu
=begin
  present options to the user (list, lookup, exit)
  validate user input
  go to users selected option from the menu
=end
  end

  def movie_list
    Movie.create_from_collection(Scraper.scrape_list)

    puts ''
    Movie.all.each_with_index { |v, i|
      puts "#{i + 1}  #{v.title}"
      puts "#{v.description}"
      puts "  #{v.metascore} Metascore" unless v.metascore == ''
      puts ''
    }

=begin
  options are more info on movie in the list, or exit
  validation for list_choices
  go to selected list choice
=end
  end

end
