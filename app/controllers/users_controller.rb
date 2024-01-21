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
      session[:user_id] = @user.id
      redirect_to users_url, notice: "#{@user.name} created an account"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update allowed_user_params
      redirect_to @user, notice: 'Account successully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to movies_url, status: :see_other, alert: 'Account successfully deleted'
  end

  private

  def allowed_user_params
    params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
  end
end
