module ReviewsHelper
	def average_rating(reviews)
		reviews.reduce(0) { |sum, review| sum + review.stars } / reviews.size
	end
end
