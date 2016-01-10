class SessionsController < ApplicationController
  
  def new #login
  
  end

  def create #login
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id # this is browser session hash.
      flash[:success] = "You have successfully logged in"
      redirect_to user_path(user)
    else
      flash.now[:danger] = "There was something wrong with your login information" 
      # normal flash only works on new request. this is render html only, so need use flash.now.
      render 'new'
    end
  end

  def destroy #logout
    session[:user_id] = nil
    flash[:success] = "You have logged out"
    redirect_to root_path
  end
  
end