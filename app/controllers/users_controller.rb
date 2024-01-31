class UsersController < ApplicationController
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by! slug: params[:id]
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new allowed_user_params

    if @user.save
      session[:user_id] = @user.id
      redirect_to users_url, notice: "#{@user.name} created an account"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Empty for now, user being declared in require_correct_user
  end

  def update
    if @user.update allowed_user_params
      redirect_to @user, notice: 'Account successully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to movies_url, status: :see_other, alert: 'Account successfully deleted'
  end

  private

  def require_correct_user
    @user = User.find params[:id]
    redirect_to root_url, status: :see_other unless current_user? @user
  end

  def allowed_user_params
    params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
  end
end
