class ReviewsController < ApplicationController

  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new allowed_review_params

    if @review.save
      redirect_to movie_reviews_path(@movie), notice: 'Your review was submitted successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @review = @movie.reviews.find params[:id]
  end

  def update
    @review = @movie.reviews.find params[:id]
    if @review.update allowed_review_params
      redirect_to movie_reviews_path(@movie), notice: 'Review edited successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.reviews.delete Review.find(params[:id])
    redirect_to movie_url(@movie), status: :see_other
  end

  private

  def set_movie
    @movie = Movie.find params[:movie_id]
  end

  def allowed_review_params
    params.require(:review).permit(:name, :stars, :comment)
  end

end
