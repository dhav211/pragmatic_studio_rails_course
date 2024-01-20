class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new allowed_user_params

    if @user.save
      redirect_to users_url, notice: "#{@user.name} created an account"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def allowed_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
