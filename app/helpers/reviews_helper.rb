module ReviewsHelper
  def average_rating(reviews)
    reviews.average(:stars) || 0.0
  end

  def average_rating_as_percent(reviews)
    (average_rating(reviews) / 5.0) * 100.0
  end
end
