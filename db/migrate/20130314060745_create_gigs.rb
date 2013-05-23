class CreateGigs < ActiveRecord::Migration
  def change
    create_table :gigs do |t|
      t.string :name
      t.datetime :starts_at
      t.time :duration
      t.string :price
      t.string :website_url
      t.string :email
      t.text :details
      t.string :created_by
      t.string :gig_type
      t.integer :venue_id

      t.timestamps
    end
  end
end
