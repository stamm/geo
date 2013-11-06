class ApiController < ApplicationController

  protected

  def render_json(json)
    render json: json
  end
end
