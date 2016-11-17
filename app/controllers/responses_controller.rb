class ResponsesController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, except: [:create]
  before_action :authenticate_user!, except: [:index]

  def index
    if current_user.present? && current_user.supported.blank?
      redirect_to action: :new
    elsif current_user.blank?
      redirect_to user_facebook_omniauth_authorize_path
    end
  end

  def new
    @user = current_user
  end

  def create
    current_user.update! user_params
    flash.notice = "Preferences saved!"
    redirect_to action: :index
  end

  private

  def user_params
    params.require(:user).permit(:zip, :supported, :desired, :background, :email)
  end
end
