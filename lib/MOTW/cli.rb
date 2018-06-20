
class Cli
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
    puts '  1. Show list of movies opening this week'
    puts '  2. Show detailed information on a movie'
    puts '  3. Exit'
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
    choice = nil

    screen_clear
    Movie.create_from_collection(Scraper.scrape_list)

    puts ''
    Movie.all.each_with_index { |film, index|
      line_one = "#{index + 1}. #{film.title}"
      line_one += " (#{film.metascore} Metascore)" unless film.metascore == ''
      puts line_one
      puts "#{film.description}"
      puts ''
    }
    puts '  Enter a movies number for more information'
    puts '  Or type exit to leave'

    while choice != 'exit'
      choice = gets.strip.downcase

      if choice == 'exit'
        exit
      elsif choice.to_i.between?(1, Movie.all.length)
        lookup_movie(choice.to_i - 1)
      else
        puts '  invalid input'
      end
    end
  end

end
