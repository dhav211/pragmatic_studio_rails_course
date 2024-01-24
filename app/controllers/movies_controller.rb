class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @movies = Movie.released
  end

  def show
    @movie = Movie.find params[:id]
    @review = Review.new
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    if @movie.update(allowed_movie_params)
      redirect_to @movie, notice: 'Movie updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new allowed_movie_params
    if @movie.save
      redirect_to @movie, notice: 'Movie created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    redirect_to movies_url, status: :see_other
  end

  private

  def allowed_movie_params
    params.require(:movie)
          .permit(:title, :description, :rating, :released_on, :total_gross,
                  :director, :duration, :image_file_name)
  end
end
