class IndexOnPrice < ActiveRecord::Migration
  def up
    execute 'CREATE INDEX index_on_points_price ON points USING btree (price)'
  end

  def down
    execute 'DROP INDEX index_on_points_price'
  end
end
