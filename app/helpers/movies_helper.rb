module MoviesHelper
  def total_gross(movie)
    if movie.flop?
      'FLOP!'
    else
      number_to_currency(movie.total_gross, precision: 0)
    end
  end

  def year_released(movie)
    movie.released_on.year
  end

  def nav_link_to(page, path)
    link_class = 'active' if current_page? "/movies/filter/#{page.downcase}"
    logger.info(link_class)
    link_to page, path, class: link_class
  end
end
