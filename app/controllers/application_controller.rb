class ApplicationController < ActionController::Base
  include Pundit

  before_action :gon_user, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def gon_user
    # -1 value for non-auth users
    gon.user_id = current_user&.id || -1
  end

  def user_not_authorized
    respond_to do |format|
      message = "You don't have permission to do that"
      format.html { redirect_to root_path, alert: message }
      format.json { render json: { error: message }, status: :forbidden }
      format.js do
        flash[:alert] = message
        render partial: 'shared/flash_js', status: 403
      end
    end
  end
end
