class AddFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :provider, :string
    add_column :profiles, :uid, :string
    add_column :profiles, :bio, :text, limit: nil
    add_column :profiles, :remote_avatar_url, :string
    add_column :profiles, :phone, :string
    add_column :profiles, :gender, :string
    add_column :profiles, :confirmed_at, :datetime
  end
end
