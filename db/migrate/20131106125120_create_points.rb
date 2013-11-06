class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :name
      t.integer :price
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
