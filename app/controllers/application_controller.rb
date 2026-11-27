class ApplicationController < ActionController::Base
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :admin?

  private

  # Check whether the currently logged-in user is an administrator.
  def admin?
    Current.user&.admin?
  end

  # Prevent regular users from accessing administrator-only actions.
  def require_admin
    unless admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end