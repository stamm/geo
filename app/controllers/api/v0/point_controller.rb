class Api::V0::PointController < ApiController
  respond_to :json

  def index
    if params[:bounds].blank?
      render_error({error: 'no boundes'}, 400)
    else
      @points = Point

      unless params[:price_from].blank?
        @points = @points.where('price >= ?', params[:price_from])
      end
      unless params[:price_to].blank?
        @points = @points.where('price <= ?', params[:price_to])
      end

      unless params[:polygon].blank?
        polygon = Point.string2points(params[:polygon])
        polygon << polygon.first
        @points = @points.bound(polygon)
      else
        rectangle = bound_to_rectangle(params[:bounds])
        @points = @points.bound(rectangle)
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