class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.integer :profile_id
      t.float :lat
      t.float :lng
      t.string :address
      t.integer :country_id
      t.text :about

      t.timestamps
    end
  end
end
