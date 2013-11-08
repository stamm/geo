class Point < ActiveRecord::Base
  include PointSql
  extend PointHelper

  scope :bound, -> (points) {
      where('ST_Contains(%s, %s)' % [sql_polygon(points), sql_geo_point] )
  }
  scope :filter_by_price, -> (from, to) {
    obj = self
    obj = obj.where('price >= ?', from) unless from.blank?
    obj = obj.where('price <= ?', to) unless to.blank?
    obj
  }

  def self.controller_filter(opts)

    point = filter_by_price(opts[:price_from], opts[:price_to])

    if opts[:polygon].blank?
      polygon = bound_to_rectangle(opts[:bounds])
    else
      polygon = string2points(opts[:polygon])
      polygon << polygon.first
    end
    point.bound(polygon)
  end
end
