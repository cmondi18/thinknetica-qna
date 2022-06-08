class ApplicationController < ActionController::Base
  include Pundit

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def gon_user
    # -1 value for non-auth users
    gon.user_id = current_user&.id || -1
  end

  # check_authorization
end
