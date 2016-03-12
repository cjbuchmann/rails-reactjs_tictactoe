require "#{Rails.root}/lib/persistance"

class Api::BaseController < ActionController::Base
  class BoardNotFoundError < StandardError;end

  rescue_from BoardNotFoundError do |exception|
    render json: { errors: ['Board not found'] }, status: :not_found
  end
end
