class Point < ActiveRecord::Base
  scope :rectangle, -> (latitudes, longitudes) {
    where(%{ST_Contains(ST_MakePolygon(ST_GeomFromText('LINESTRING(%f %f,%f %f, %f %f,%f %f,%f %f)')), ST_GeomFromText('POINT(' || points.longitude || ' ' || points.latitude || ')'))
} % [longitudes.min, latitudes.max, longitudes.max, latitudes.max, longitudes.max, latitudes.min, longitudes.min, latitudes.min, longitudes.min, latitudes.max])
  }
end
