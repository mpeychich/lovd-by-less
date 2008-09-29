class CreateFeedEntryProfiles < ActiveRecord::Migration
  def self.up
    create_table :feed_entry_profiles do |t|
      t.integer     :feed_entry_id
      t.integer     :profile_id
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_entry_profiles
  end
end
