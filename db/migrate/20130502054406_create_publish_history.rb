class CreatePublishHistory < ActiveRecord::Migration
  def change
    create_table :publish_histories do |t|
      t.integer :gig_id
      t.string :provider
      t.datetime :posted_at

      t.timestamps
    end
  end
end
