class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries do |t|
      t.string      :type
      t.integer     :group_on_id
      t.text        :targets
      t.integer     :count,         :default => 1, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_entries
  end
end
