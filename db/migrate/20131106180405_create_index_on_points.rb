class CreateIndexOnPoints < ActiveRecord::Migration
  def up
    execute "CREATE INDEX index_on_points_location ON points using gist (
        ST_GeomFromText(
          'POINT(' || points.longitude || ' ' || points.latitude || ')'
        )
      );"
  end

  def down
    execute 'DROP INDEX index_on_points_location'
  end
end
