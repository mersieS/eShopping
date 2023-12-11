class ApplicationController < ActionController::Base
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Pundit::Authorization

    skip_before_action :verify_authenticity_token
    before_action :configure_permitted_parameters, if: :devise_controller?

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def user_not_authorized
        @message = "You have not auth"
        render json: {message: @message}, status: 401
    end
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username, :email, :password, :password_confirmation])
    end
end
