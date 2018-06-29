
class Cli
  attr_accessor :user_input

  def start
    system 'clear'
    system 'cls'
    puts ''
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts '|                                       |'
    puts '|  Welcome to Movies Opening This Week  |'
    puts '|                                       |'
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts ''
    menu
  end

  def menu
    options = ['1', '2', '3']

    puts ''
    puts 'Please select an option by entering its number:'
    puts '  1. Show list of movies opening this week'
    puts '  2. Lookup detailed information on a movie'
    puts '  3. Exit'
    puts ''
    self.user_input = gets.strip.downcase

    if options.include?(self.user_input)
      case self.user_input
      when '1'
        movie_list
      when '2'
        search_target
      when '3'
        goodbye
      end
    else
      puts ''
      puts '  invalid input'
      menu
    end
  end

  def movie_list
    list = Scraper.scrape_list

    puts ''
    list.each_with_index do |film, index|
      line_one = "#{index + 1}. #{film.title}"
      line_one += " (#{film.metascore} Metascore)" unless film.metascore == ''
      puts line_one
      puts "  #{film.description}"
      puts ''
    end
    puts ''
    puts '  Enter a movies number for more information'
    puts "  or enter 'lookup' if you'd like more information on a film"
    puts '  otherwise type "exit" to leave'
    puts ''

    self.user_input = nil
    while self.user_input != 'exit'
      self.user_input = gets.strip.downcase

      if self.user_input == 'exit'
        goodbye
      elsif self.user_input.to_i.between?(1, list.length)
        selected_picture = list[self.user_input.to_i - 1]
        self.user_input = selected_picture.title.gsub(/\W+/, '_')
        lookup_movie
      elsif self.user_input == 'lookup'
        search_target
      else
        puts ''
        puts '  invalid input'
        menu
      end
    end
  end

  def search_target
    puts ''
    puts '  Please enter the name of the movie you want to lookup'
    puts '  Or type exit to leave'
    puts ''
    self.user_input = gets.strip.downcase.gsub(/\p{P}/, '').gsub(/\W+/, '_')
    lookup_movie
  end

  def lookup_movie
    case self.user_input
    when 'exit'
      goodbye
    else
      tv = Scraper.scrape_movie(self.user_input)
    end

    unless tv
      puts ''
      puts '  No results found.'
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
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts '|                                             |'
    puts '|  Thanks for using Movies Opening This Week  |'
    puts '|                                             |'
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts ''
    exit
  end

end
