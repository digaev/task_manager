class Web::ApplicationController < ApplicationController
  include UserSession

  rescue_from ActiveRecord::RecordNotFound do
    render status: 404, plain: 'Not found.'
  end
end
