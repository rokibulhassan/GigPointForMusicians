class DropCountriesTable < ActiveRecord::Migration
  def up
    drop_table :countries
  end

  def down
    create_table :countries do |t|
      t.string :name

      t.timestamps
    end
  end
end
