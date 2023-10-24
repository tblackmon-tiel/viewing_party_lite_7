# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @facade = UserFacade.new(params[:id])
    # @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    params = user_params
    params[:email] = params[:email].downcase
    new_user = User.new(params)
    if new_user.save
      flash[:success] = 'New account created successfully.'
      redirect_to user_path(new_user)
    else
      flash[:error] = new_user.errors.full_messages.to_sentence
      render :new
    end
  end

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      flash[:success] = "Logged in successfully!"
      redirect_to user_path(user)
    else
      flash[:error] = "Sorry, your credentials are incorrect!"
      render :login_form
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
