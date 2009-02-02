class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries do |t|
      t.string      :type
      t.integer     :ref_id
      t.integer     :associated_id
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_entries
  end
end
