class UsersController < ApplicationController
  before_action :set_user, only: %i[update destroy]

  def index
    @users = User.all
  end

  def update
    respond_to do |format|
      if admin_check && @user.update(user_params)
        format.html {
          flash.now[:success] = "success"
        }
      else
        format.html {
          flash.now[:danger] = "fail"
        }
      end
    end
  end

  def destroy
    deleted_name = @user.email
    @user.destroy
    respond_to do |format|
      format.html {
        flash[:success] = "#{deleted_name}を削除しました"
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:admin, :bartender)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin_check
    User.all.count { |u| u.admin } > 1
  end
end
