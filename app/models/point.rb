class Point < ActiveRecord::Base

  def self.bound(points)
    where(%{ST_Contains(ST_MakePolygon(ST_GeomFromText('LINESTRING(%s)')), ST_GeomFromText('POINT(' || points.longitude || ' ' || points.latitude || ')'))
} % [get_geom(points)] )
  end

  def self.get_geom(points)
    points.map do |point|
      '%.8f %.8f' % [point[1], point[0]]
    end.join(',')
  end

  def self.parse_point(str)
    str.split(',').map(&:to_f).reject { |n| n == 0 }
  end
end
