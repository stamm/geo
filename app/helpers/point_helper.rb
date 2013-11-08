module PointHelper
  def to_postgis_format(points)
    points.map { |p| '%.8f %.8f' % [p[1], p[0]] } .join(',')
  end

  def string2floats(str)
    str.split(',').map(&:to_f).reject { |n| n == 0 }
  end

  def string2points(str)
    string2floats(str).each_slice(2).to_a
  end

  def bound_to_rectangle(bounds_string)
    bounds = string2floats(bounds_string)
    [
        [bounds[0], bounds[1]],
        [bounds[2], bounds[1]],
        [bounds[2], bounds[3]],
        [bounds[0], bounds[3]],
        [bounds[0], bounds[1]]
    ]
  end
end