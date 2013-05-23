class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.integer :profile_id

      t.timestamps
    end
  end
end
