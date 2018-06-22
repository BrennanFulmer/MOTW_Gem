
=begin
  TODO
  1. cli interaction for movie lookup (both initial menu option and post list)

  2. add an exit method with a goodbye message

  3. improve welcome message
=end

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
        # TODO this will likely need to be changed
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
    Movie.create_list( Scraper.scrape_list ) if Movie.list == []

    puts ''
    Movie.list.each_with_index { |film, index|
      line_one = "#{index + 1}. #{film.title}"
      line_one += " (#{film.metascore} Metascore)" unless film.metascore == ''
      puts line_one
      puts "#{film.description}"
      puts ''
    }

    puts ''
    puts '  Enter a movies number for more information'
    puts "  or enter 'lookup' if you'd like more information on a different film"
    puts '  otherwise type "exit" to leave'
    puts ''

    choice = nil
    while choice != 'exit'
      choice = gets.strip.downcase

      if choice == 'exit'
        exit
      elsif choice.to_i.between?(1, Movie.list.length)
        # TODO this will likely need to be changed
        more_movie(choice.to_i - 1)
      elsif choice == 'lookup'
        lookup_movie
      else
        puts '  invalid input'
      end
    end
  end

  def lookup_movie
    puts ''
    puts '  Please enter the name of the movie you want to lookup'
    puts '  Or type exit to leave'
    puts ''
    search_term = gets.strip.downcase.gsub(/\s+/i, '_')

    case search_term
    when 'exit'
      exit
    else
      result = Movie.new( Scraper.scrape_movie(search_term) )
    end

    puts ''
    puts "#{result.title}"
    puts "#{result.critic_tomatometer}"
    puts "#{result.user_tomatometer}"
    puts "#{result.consensus}"
    puts "#{result.description}"
    puts "#{result.cast}"
    puts "#{result.genre}"
    puts "#{result.director}"
    puts "#{result.studio}"
    puts "#{result.writer}"
    puts "#{result.rated}"
    puts "#{result.duration}"
    puts "#{result.year}"
    puts ''

binding.pry
  end

end
