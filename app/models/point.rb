class Point < ActiveRecord::Base
  include PointSql
  extend PointHelper

  scope :bound, -> (points) {
      where('ST_Contains(%s, %s)' % [sql_polygon(points), sql_geo_point] )
  }
  scope :filter_by_price, -> (from, to) {
    where('price >= ?', from) unless from.blank?
    where('price <= ?', to) unless to.blank?
  }
end
