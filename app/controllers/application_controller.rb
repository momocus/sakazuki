class ApplicationController < ActionController::Base
  def signed_in_user
    return if user_signed_in?

    flash[:danger] = "Please sign in."
    redirect_to new_user_session_path
  end
end
