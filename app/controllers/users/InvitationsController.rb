module Users
  class InvitationsController < Devise::InvitationsController
    before_action :accept_admin, only: %i[new create]

    private

    # 招待メールを送れるのはadmin限定とする
    def accept_admin
      return if current_user.admin

      flash[:danger] = t(".permission_denied")
      redirect_to(root_url)
    end
  end
end
