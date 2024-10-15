class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'test' && password == '123'
    end
  end
end
