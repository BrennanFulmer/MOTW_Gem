=begin
TODO
1. finish scrape_movie
2. split methods into public, private, and maybe protected
3. if nil value processing is improved down the line remove it from here
=end

class Scraper
  def self.scrape_list
    imdb = Nokogiri::HTML(open("https://www.imdb.com/movies-in-theaters"))
    movie_list = []

    imdb.css('div.sub-list')[0].css('div.list_item').each { |element|
      movie = {
        cast: list_cast(element),
        description: strip_text( element.css('div.outline') ),
        director: strip_text( element.css('div.txt-block a')[0] ),
        duration: strip_text( element.css('time') ),
        genre: list_genre(element),
        metascore: strip_text( element.css('div.rating_txt span')[0] ),
        rating: list_rating(element),
        title: list_title(element)
      }
      movie_list.push(movie)
    }

    movie_list
  end

  def self.list_cast(node)
    if node.css('div.txt-block a')[1]
      node.css('div.txt-block a').collect { |star|
        star.text.strip
      }.drop(1).join(' | ')
    else
      ''
    end
  end

  def self.strip_text(node)
    node ? node.text.strip : ''
  end

  def self.list_genre(node)
    if node.css('p.cert-runtime-genre span')[0]
      node.css('p.cert-runtime-genre span').collect { |genre|
        genre.text.strip
      }.join.gsub('|', ' | ')
    else
      ''
    end
  end

  def self.list_rating(node)
    if lr = node.css('img')[1]
      lr.attribute('title').value.strip
    else
      ''
    end
  end

  def self.list_title(node)
    if lt = node.css('a')[1]
      lt.text.strip.split(' (')[0]
    else
      ''
    end
  end

  def self.scrape_movie(film_name)
=begin
    'princess_bride'
    'incredibles_2'
=end
    rt = Nokogiri::HTML(open("https://rottentomatoes.com/m/#{film_name}"))

    film = {
      # strip out extra spacing and attribute title
      # consensus: strip_text( rt.css('p.critic_consensus')[0] ),
      critic_tomatometer: strip_text( rt.css('div.critic-score')[0] ),
      description: strip_text( rt.css('div.movie_synopsis') ),
      director: strip_text( rt.css('li.meta-row div.meta-value')[2] ),
      duration: movie_duration(rt),
      genre: movie_genre(rt),
      rating: strip_text( rt.css('li.meta-row div.meta-value')[0] ),
      studio: movie_studio(rt),
      title: strip_text( rt.css('h1.title')[0] ),
      user_tomatometer: strip_text( rt.css('div.audience-score span.superPageFontColor') ),
      writer: strip_text( rt.css('li.meta-row div.meta-value')[3] ),
      year: strip_text(  rt.css('span.year')[0] )
    }

=begin
    TODO use collect then convert to string, and combine these two
  cast = rt.css('div.cast-item span')[0].text.strip if rt.css('div.cast-item span')[0]
  role = rt.css('div.cast-item span')[1].text.strip if rt.css('div.cast-item span')[1]
=end
binding.pry
  end

  def self.movie_duration(page)
    time_1 = page.css('div.meta-value time')[1]
    time_2 = page.css('div.meta-value time')[2]

    if time_1 && time_1.text.include?('minutes')
      time_1.text.strip
    elsif time_2 && time_2.text.include?('minutes')
      time_2.text.strip
    else
      ''
    end
  end

  def self.movie_genre(page)
    if page.css('li.meta-row')[1].css('a')[0]
      page.css('li.meta-row')[1].css('a').collect { |type|
        type.text.strip
      }.join(' | ')
    else
      ''
    end
  end

  def self.movie_studio(page)
    meta_table = page.css('li.meta-row div.meta-value')

    if meta_table && meta_table[0]
      meta_table.each_with_index { |ele, index|
        if ele.text.include?('minutes')
          return meta_table[index + 1].text.strip
        end
      }
    else
      ''
    end
  end

end
