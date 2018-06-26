
class Cli

  def start
    screen_clear
    puts ''
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts '|                                       |'
    puts '|  Welcome to Movies Opening This Week  |'
    puts '|                                       |'
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts ''
    menu
  end

  def screen_clear
    system 'clear'
    system 'cls'
  end

  def menu
    options = ['1', '2', '3']

    puts ''
    puts 'Please select an option by entering its number:'
    puts '  1. Show list of movies opening this week'
    puts '  2. Lookup detailed information on a movie'
    puts '  3. Exit'
    puts ''
    input = gets.strip.downcase

    if options.include?(input)
      case input
      when '1'
        movie_list
      when '2'
        search_target
      when '3'
        goodbye
      end
    else
      menu
    end
  end

  def movie_list
    screen_clear
    Movie.create_list( Scraper.scrape_list ) if Movie.list == []

    puts ''
    Movie.list.each_with_index do |film, index|
      line_one = "#{index + 1}. #{film.title}"
      line_one += " (#{film.metascore} Metascore)" unless film.metascore == ''
      puts line_one
      puts "#{film.description}"
      puts ''
    end
    puts ''
    puts '  Enter a movies number for more information'
    puts "  or enter 'lookup' if you'd like more information on a film"
    puts '  otherwise type "exit" to leave'
    puts ''

    choice = nil
    while choice != 'exit'
      choice = gets.strip.downcase

      if choice == 'exit'
        goodbye
      elsif choice.to_i.between?(1, Movie.list.length)
        selected_picture = Movie.list[choice.to_i - 1]
        formatted_title = selected_picture.title.gsub(/\W+/, '_')
        lookup_movie(formatted_title)
      elsif choice == 'lookup'
        lookup_movie
      else
        puts ''
        puts '  invalid input'
        puts ''
        menu
      end
    end
  end

  def search_target
    puts ''
    puts '  Please enter the name of the movie you want to lookup'
    puts '  Or type exit to leave'
    puts ''
    search_term = gets.strip.downcase.gsub(/\p{P}/, '').gsub(/\W+/, '_')
    lookup_movie(search_term)
  end

  def lookup_movie(search_term)
    case search_term
    when 'exit'
      goodbye
    else
      tv = Movie.new( Scraper.scrape_movie(search_term) )
    end

    unless tv.title
      puts ''
      puts 'No results found.'
      puts ''
    else
      first_line = "  #{tv.title}"
      if tv.critic_tomatometer != '' && tv.user_tomatometer != ''
        first_line += " - Tomatometer (#{tv.critic_tomatometer} critic) (#{tv.user_tomatometer} user)"
      elsif tv.critic_tomatometer != ''
        first_line += " (Critic Tomatometer #{tv.critic_tomatometer})"
      elsif tv.user_tomatometer != ''
        first_line += " (User Tomatometer #{tv.user_tomatometer})"
      end
      puts ''
      puts first_line
      puts ''
      puts "  Description: #{tv.description}"
      puts ''
      puts "  Starring: #{tv.cast}"
      puts ''
      puts "  Release Year: #{tv.year}"
      puts ''
    end

    menu
  end

  def goodbye
    puts ''
    puts ''
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts '|                                             |'
    puts '|  Thanks for using Movies Opening This Week  |'
    puts '|                                             |'
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts ''
    puts ''
    exit
  end

end
