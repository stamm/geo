class ApiController < ApplicationController

  protected

  def render_json(json)
    render json: json
  end

  def render_error(json, status)
    render json: json, status: status
  end
end
