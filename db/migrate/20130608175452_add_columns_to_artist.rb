class AddColumnsToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :name, :string
    add_column :artists, :email, :string
    add_column :artists, :url, :string
    add_column :artists, :tel, :string
    add_column :artists, :description, :text
  end
end
