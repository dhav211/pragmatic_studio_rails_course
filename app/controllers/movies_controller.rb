class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    @movies = Movie.send(movies_filter)
  end

  def show
    @review = Review.new
    @fans = @movie.fans
    @favorite = current_user.favorites.find_by movie_id: @movie.id if current_user
    @genres = @movie.genres
  end

  def edit
    # Empty for time being, before-action set_movie is doing all the work
  end

  def update
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
    @movie.destroy
    redirect_to movies_url, status: :see_other
  end

  private

  def set_movie
    @movie = Movie.find_by! slug: params[:id]
  end

  def allowed_movie_params
    params.require(:movie)
          .permit(:title, :description, :rating, :released_on, :total_gross,
                  :director, :duration, :image_file_name, genre_ids: [])
  end

  def movies_filter
    if params[:filter].in? %w[upcoming recent hits flops]
      params[:filter]
    else
      :released
    end
  end
end
