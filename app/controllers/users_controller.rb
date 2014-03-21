class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :not_signed_in_user, only: [:new, :create]

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to this awesome app! This is your profile page yay!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Your profile is updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user_name = user.name
    user.destroy
    flash[:success] = "#{user_name} was successfully eliminated."
    redirect_to users_path
  end

private
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in"
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def not_signed_in_user
    if signed_in?
      redirect_to root_path, notice: "You're already signed in"
    end
  end
end
