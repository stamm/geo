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
end