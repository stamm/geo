module PointSql
  extend ActiveSupport::Concern

  module ClassMethods
    def sql_polygon(points)
      "ST_MakePolygon(ST_GeomFromText('LINESTRING(%s)'))" % [to_postgis_format(points)]
    end

    def sql_geo_point
      "ST_GeomFromText('POINT(' || points.longitude || ' ' || points.latitude || ')')"
    end
  end
end