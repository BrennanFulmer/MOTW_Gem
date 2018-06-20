
# TODO split methods into public, private, and maybe protected

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
    rt = Nokogiri::HTML(open("https://rottentomatoes.com/m/#{film_name}"))

    film = {
      cast: movie_cast(rt),
      consensus: movie_consensus(rt),
      critic_tomatometer: strip_text( rt.css('div.critic-score')[0] ),
      description: strip_text( rt.css('div.movie_synopsis') ),
      director: strip_text( rt.css('li.meta-row div.meta-value')[2] ),
      duration: movie_duration(rt),
      genre: movie_genre(rt),
      rating: strip_text( rt.css('li.meta-row div.meta-value')[0] ),
      studio: movie_studio(rt),
      title: strip_text( rt.css('h1.title')[0] ),
      user_tomatometer: user_tomatometer(rt),
      writer: strip_text( rt.css('li.meta-row div.meta-value')[3] ),
      year: strip_text(  rt.css('span.year')[0] )
    }
  end

  def self.movie_cast(page)
    with_role = []

    if page.css('div.cast-item span')[0]
      page.css('div.cast-item span').each_with_index { |value, key|
        star = value.text.strip

        if star[0..2] == 'as '
          with_role[-1] += " #{star}"
        else
          with_role << star
        end
      }

      with_role
    else
      ''
    end
  end

  def self.movie_consensus(page)
    mc = page.css('p.critic_consensus')[0]

    if mc && !mc.text.include?('No consensus yet.')
      mc.text.split('Critics Consensus:')[1].strip
    else
      ''
    end
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
      ''
    else
      ''
    end
  end

  def self.user_tomatometer(page)
    score = page.css('div.meter-value span.superPageFontColor').text.strip
    context = page.css('div.meter-value div.superPageFontColor').text.strip

    unless score == '' || context == 'want to see'
      score
    else
      ''
    end
  end

end
