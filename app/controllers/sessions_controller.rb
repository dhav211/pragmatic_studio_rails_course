class SessionsController < ApplicationController
  def new
    # Don't need anything here
  end

  def create
    user = User.find_by username: params[:username]
    if !user.nil? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back, #{user.name}"
    else
      flash.now[:alert] = 'Incorrect username/password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to movies_url, status: :see_other, notice: "You successfully signed out"
  end
end
