class CreateSchedulePosts < ActiveRecord::Migration
  def change
    create_table :schedule_posts do |t|
      t.integer :gig_id
      t.integer :user_id
      t.boolean :post_facebook, :default => false
      t.boolean :post_twitter, :default => false
      t.boolean :post_immediately, :default => false
      t.boolean :post_a_week_before, :default => false
      t.boolean :post_a_day_before, :default => false
      t.boolean :post_the_day_off, :default => false

      t.timestamps
    end
  end
end
