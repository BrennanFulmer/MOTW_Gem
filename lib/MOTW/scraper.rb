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

  def self.scrape_movie # (search_term)
    search = 'incredibles_2'
    rt = Nokogiri::HTML(open("https://rottentomatoes.com/m/#{search}"))

    film = {
      description: if g = rt.css('div.movie_synopsis') then g.text.strip end,
      genre: movie_genre(rt),
      title: if h = rt.css('h1.title')[0] then h.text.strip end
    }

=begin
    title = rt.css('h1.title')[0].text.strip if rt.css('h1.title')[0]
    description = rt.css('div.movie_synopsis').text.strip if rt.css('div.movie_synopsis')
      # TODO use collect then convert to string
      genre = rt.css('div.meta-value a')[0].text.strip if rt.css('div.meta-value a')[0]
    critic_tomatometer = rt.css('div.critic-score')[0].text.strip if rt.css('div.critic-score')[0]
    user_tomatometer = rt.css('div.audience-score span.superPageFontColor').text.strip if rt.css('div.audience-score span.superPageFontColor')
      # TODO use collect then convert to string, and combine these two
      cast = rt.css('div.cast-item span')[0].text.strip if rt.css('div.cast-item span')[0]
      role = rt.css('div.cast-item span')[1].text.strip if rt.css('div.cast-item span')[1]
    rating = rt.css('li.meta-row div.meta-value')[0].text.strip if rt.css('li.meta-row div.meta-value')[0]
    director = rt.css('li.meta-row div.meta-value')[2].text.strip if rt.css('li.meta-row div.meta-value')[2]
      # if the movie is available on DVD its rt.css('div.meta-value time')[2].text.strip
      duration = rt.css('div.meta-value time')[1].text.strip if rt.css('div.meta-value time')[1]
    writer = rt.css('li.meta-row div.meta-value')[3].text.strip if rt.css('li.meta-row div.meta-value')[3]
      # if the movie is available on DVD its rt.css('li.meta-row div.meta-value')[7].text.strip
      studio = rt.css('li.meta-row div.meta-value')[6].text.strip if rt.css('li.meta-row div.meta-value')[6]
    consensus = rt.css('p.critic_consensus')[0].text.strip
    year = rt.css('span.year')[0].text.strip if rt.css('span.year')[0]
=end
binding.pry
  end

  def self.movie_genre(page)
    if page.css('li.meta-row')[1].css('a')[0]
      page.css('li.meta-row')[1].css('a').collect { |type|
        type.text.strip
      }.join(' | ')
    end
  end

end
