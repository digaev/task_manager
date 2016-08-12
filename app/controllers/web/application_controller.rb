class Web::ApplicationController < ApplicationController
  include UserSession

  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound do
    render status: 404, plain: 'Not found.'
  end
end
