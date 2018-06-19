
class Cli
  # attr_accessor :input

  def initialize
    screen_clear
    puts 'Welcome to Movies Opening this Week'
    menu
  end

  def screen_clear
    system 'clear'
    system 'cls'
  end

  def menu
    options = ['1', '2', '3', 'exit']

    puts ''
    puts 'Please select an option by entering its number:'
    puts '1. Show list of movies opening this week'
    puts '2. Show detailed information on a movie'
    puts '3. Exit'
    puts ''
    input = gets.strip.downcase

    if options.include?(input)
      case input
      when '1'
        movie_list
      when '2'
        lookup_movie
      when '3' || 'exit'
        exit
      end
    else
      menu
    end
  end

  def movie_list
    screen_clear
    Movie.create_from_collection(Scraper.scrape_list)

    puts ''
    Movie.all.each_with_index { |v, i|
      puts "#{i + 1}. #{v.title}"
      puts "  #{v.metascore} Metascore" unless v.metascore == ''
      puts "#{v.description}"
      puts ''
    }

=begin
  options are more info on movie in the list, or exit
  validation for list_choices
  go to selected list choice
=end
  end

end
