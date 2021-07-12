module Users
  include ApplicationHelper

  class RegistrationsController < Devise::RegistrationsController
    before_action :redirect_to_root, only: %i[new create]

    # rubocop:disable Lint/UselessMethodDefinition

    # GET /resource/sign_up
    def new
      super
    end

    # POST /resource
    def create
      super
    end

    # rubocop:enable Lint/UselessMethodDefinition

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    private

    def redirect_to_root
      flash[:danger] = t("controllers.user.permission_denied")
      redirect_to(root_url)
    end
  end
end
