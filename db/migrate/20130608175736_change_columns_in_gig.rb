class ChangeColumnsInGig < ActiveRecord::Migration
  def change
    rename_column :gigs, :name, :title
    rename_column :gigs, :price, :admission
    rename_column :gigs, :website_url, :url
    rename_column :gigs, :details, :description
    rename_column :gigs, :user_id, :creator_id
  end
end
