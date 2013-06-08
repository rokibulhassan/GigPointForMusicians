class RemoveColumnsFromGig < ActiveRecord::Migration
  def up
    remove_column :gigs, :created_by
    remove_column :gigs, :gig_type
    remove_column :gigs, :extra_info
    remove_column :gigs, :latitude
    remove_column :gigs, :longitude
    remove_column :gigs, :gmaps
    remove_column :gigs, :others
  end

  def down
    add_column :gigs, :created_by, :integer
    add_column :gigs, :gig_type, :string
    add_column :gigs, :extra_info, :string
    add_column :gigs, :latitude, :float
    add_column :gigs, :longitude, :float
    add_column :gigs, :gmaps, :string
    add_column :gigs, :others, :string
  end
end
