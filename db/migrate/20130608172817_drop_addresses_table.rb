class DropAddressesTable < ActiveRecord::Migration
  def up
    drop_table :addresses
  end

  def down
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.integer :addressable_id
      t.string :addressable_type
      t.timestamps
    end
  end
end
