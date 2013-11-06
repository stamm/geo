class Api::V0::PointController < ApiController
  respond_to :json

  def index
    if params[:latitude].blank? && params[:longitude].blank?

    end
    @points = Point

    unless params[:price_from].blank?
      @points = @points.where('price >= ?', params[:price_from])
    end
    unless params[:price_to].blank?
      @points = @points.where('price <= ?', params[:price_to])
    end
    @points = @points.rectangle(params[:latitude].map(&:to_f), params[:longitude].map(&:to_f))
    #render_json({data: json})
  end

end