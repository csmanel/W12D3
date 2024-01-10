class Api::SessionsController < ApplicationController
  def show
    @user = current_user 
    @user ? render 'api/users/show' : render json: { user: nil }
    end
  end

  def create
    username = params[:username]
    password = params[:password]
    @user = user.find_by_credentials(username, password)
    @user ? render 'api/users/show' :  render json: { errors: ['Invalid credentials'] }, status: 422
  end

  def destroy
    logout
    head :no_content
  end
end