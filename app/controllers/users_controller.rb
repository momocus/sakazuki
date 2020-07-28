class UsersController < ApplicationController
  before_action :self_or_admin_user, only: %i[show edit update]
  before_action :admin_user, only: %i[new create index destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User created"
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def self_or_admin_user
    @user = User.find(params[:id])
    return if @user == current_user

    admin_user
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = "Permission denied."
    redirect_to(root_url)
  end
end
