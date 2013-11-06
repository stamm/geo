namespace :db do
  desc 'Fill database with sample data'
  task sample_data: :environment do
    make_moscow
    make_piter
  end
end

def make_moscow
  1200.times do |i|
    Point.create!(
        name: "Point#{i}",
        price: Random.rand(5_000_000..100_000_00),
        latitude: Random.rand(55.5770..55.8947),
        longitude:  Random.rand(37.3828..37.8635)
    )
  end
end

def make_piter
  800.times do |i|
    Point.create!(
        name: "Point#{i}",
        price: Random.rand(1_000_000..12_000_00),
        latitude: Random.rand(59.8314..60.0478),
        longitude:  Random.rand(30.2170..30.4971)
    )
  end
end