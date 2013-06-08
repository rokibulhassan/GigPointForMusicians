class AddColumnsToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :tel, :string
    add_column :venues, :url, :string
    add_column :venues, :email, :string
    add_column :venues, :address1, :string
    add_column :venues, :address2, :string
    add_column :venues, :address3, :string
    add_column :venues, :address4, :string
    add_column :venues, :city, :string
    add_column :venues, :state, :string
    add_column :venues, :postcode, :string
    add_column :venues, :country, :string
  end
end
