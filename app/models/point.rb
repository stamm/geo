class Point < ActiveRecord::Base

  
  class << self

    def bound(points)
      where('ST_Contains(%s, %s)' % [sql_polygon(points), sql_geo_point] )
    end
  
    def sql_polygon(points)
      "ST_MakePolygon(ST_GeomFromText('LINESTRING(%s)'))" % [get_geom(points)]
    end
  
    def sql_geo_point
      "ST_GeomFromText('POINT(' || points.longitude || ' ' || points.latitude || ')')"
    end
  
    def get_geom(points)
      points.map { |p| '%.8f %.8f' % [p[1], p[0]] } .join(',')
    end
  
    def string2floats(str)
      str.split(',').map(&:to_f).reject { |n| n == 0 }
    end

    def string2points(str)
      string2floats(str).each_slice(2).to_a
    end
  end
end
