module CheckPermission
  extend ActiveSupport::Concern


  included do
    before_action :authenticate_user!, unless: :devise_controller?
    before_action :check_permission, unless: :devise_controller?
  end

  def permissions
    {
        tickets: {
            registered: [:index, :create, :reply, :close, :reopen],
            support: [:index, :reply, :close, :reopen],
            admin: []
        },

        users: {
            admin: [:create, :update, :index, :show, :destroy]
        }
    }
  end


  def check_permission
    controller_permissions = permissions[controller_name.to_sym]
    role = current_user.role.to_sym
    if controller_permissions.keys.include?(role)
      if !controller_permissions[role].include?(action_name.to_sym)
        head 403
      end
    else
      head 403
    end
  end
end

