
class Cli
  # attr_accessor

  def initialize
    # greets, and calls methods
  end

  def menu
    # present options to the user (list, lookup, exit)
  end

  def valid_menu_input
    # validate user input
  end

  def call_menu_option
    # go to users selected option from the menu
  end

  def movie_list
    Movie.create_from_collection(Scraper.scrape_list)
    display_list
    list_choices
  end

  def display_list
    puts ''
    Movie.all.each_with_index { |v, i|
      puts "#{i + 1}  #{v.title}"
      puts "#{v.description}"
      puts "  #{v.metascore} Metascore" unless v.metascore == ''
      puts ''
    }
  end

  def list_choices
    # options are more info on movie in the list, or exit
  end

  def valid_list_choice
    # validation for list_choices
  end

  def call_list_option
    # go to selected list choice
  end

end
