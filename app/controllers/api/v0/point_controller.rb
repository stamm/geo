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
      bounds = params[:bounds].split(',').map(&:to_f).reject { |n| n == 0 }

      rectangle = [
          [bounds[0], bounds[1]],
          [bounds[2], bounds[1]],
          [bounds[2], bounds[3]],
          [bounds[0], bounds[3]],
          [bounds[0], bounds[1]]
      ]

      if bounds.size == 4
        @points = @points.bound(rectangle)
      else
        render_error({error: 'no boundes'}, 400)
      end

      #render_json({data: json})
    end
  end

end