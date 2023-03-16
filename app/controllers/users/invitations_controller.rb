module Users
  class InvitationsController < Devise::InvitationsController
    before_action :accept_admin, only: %i[new create]

    # rubocop:disable Lint/UselessMethodDefinition
    def new
      super
    end

    def create
      super
    end

    # rubocop:enable Lint/UselessMethodDefinition

    private

    # 招待メールを送れるのはadmin限定とする
    def accept_admin
      return if current_user.admin

      redirect_to(root_url, flash: { danger: t(".permission_denied") })
    end
  end
end
