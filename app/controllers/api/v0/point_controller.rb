class Api::V0::PointController < ApiController
  respond_to :json

  def index
    if params[:bounds].blank?
      render_error({error: 'no boundes'}, 400)
    else
      @points = Point.controller_filter(params)
    end
  end


end