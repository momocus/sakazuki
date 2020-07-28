class ApplicationController < ActionController::Base
  include SessionsHelper
  def signed_in_user
    return if signed_in?

    flash[:danger] = "Please sign in."
    redirect_to signin_url
  end
end
