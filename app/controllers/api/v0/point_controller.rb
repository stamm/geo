class Api::V0::PointController < ApiController
  respond_to :json

  def index
    if params[:bounds].blank?
      render_error({error: 'no boundes'}, 400)
    else
      @points = Point

      @points = @points.filter_by_price(params[:price_from], params[:price_to])

      if params[:polygon].blank?
        rectangle = bound_to_rectangle(params[:bounds])
        @points = @points.bound(rectangle)
      else
        polygon = Point.string2points(params[:polygon])
        polygon << polygon.first
        @points = @points.bound(polygon)
      end
    end
  end

  private

  def bound_to_rectangle(bounds_string)
    bounds = Point.string2floats(bounds_string)
    [
      [bounds[0], bounds[1]],
      [bounds[2], bounds[1]],
      [bounds[2], bounds[3]],
      [bounds[0], bounds[3]],
      [bounds[0], bounds[1]]
    ]
  end

end