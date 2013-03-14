class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :user_name
      t.string :website_url
      t.string :photo
      t.integer :rating

      t.timestamps
    end
  end
end
