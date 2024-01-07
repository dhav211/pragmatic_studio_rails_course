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
end
