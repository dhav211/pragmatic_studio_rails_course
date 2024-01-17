module ReviewsHelper
  def average_rating(reviews)
    reviews_sum = reviews.reduce(0) { |sum, review| sum + review.stars }
    reviews_sum.positive? ? reviews_sum / reviews.size : 0
  end
end
