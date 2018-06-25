
=begin
  TODO
  - movie lookup missing data handling and post options
  - add an exit method with a goodbye message
  - improve welcome message
  - review checklist, SPEC, & README
  - record walkthrough
  - write blog post
=end

class Cli
  
  def start
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
        exit
      elsif choice.to_i.between?(1, Movie.list.length)
        selected_picture = Movie.list[choice.to_i - 1]
        formatted_title = selected_picture.title.gsub(/\W+/, '_')
        lookup_movie(formatted_title)
      elsif choice == 'lookup'
        lookup_movie
      else
        puts '  invalid input'
      end
    end
  end

  def search_target
    puts ''
    puts '  Please enter the name of the movie you want to lookup'
    puts '  Or type exit to leave'
    puts ''
    search_term = gets.strip.downcase.gsub(/\s+/i, '_')
    lookup_movie(search_term)
  end

  def lookup_movie(search_term)
    case search_term
    when 'exit'
      exit
    else
      tv = Movie.new( Scraper.scrape_movie(search_term) )
    end

# this needs to hide missing data
    screen_clear
    puts ''
    puts "  #{tv.title} - Tomatometer (#{tv.critic_tomatometer} critic) (#{tv.user_tomatometer} user)"
    puts ''
    puts "  Critics Consensus: #{tv.consensus}"
    puts ''
    puts "  Description: #{tv.description}"
    puts ''
    puts "  Starring: #{tv.cast}"
    puts ''
    puts "  Genres: #{tv.genre}"
    puts ''
    puts "  Director: #{tv.director}, Studio: #{tv.studio}, Writer: #{tv.writer}"
    puts ''
    puts "  Rating: #{tv.rated}, Runtime: #{tv.duration}, Release Year: #{tv.year}"
    puts ''

# add options
  end

end
