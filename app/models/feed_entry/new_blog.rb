# == Schema Information
# Schema version: 20080919221242
#
# Table name: feed_entries
#
#  id            :integer(11)   not null, primary key
#  type          :string(255)   
#  group_on_id   :integer(11)   
#  targets       :text          
#  count         :integer(11)   default(1), not null
#  created_at    :datetime      
#  updated_at    :datetime      
#  group_on_type :string(255)   
#  metadata      :text          
#

class FeedEntry::NewBlog < FeedEntry
  belongs_to :blog, :class_name => "::Blog", :foreign_key => "ref_id"
  
  class << self
    def acceptable?(record)
      record.is_a?(Blog)
    end
  end
  
  def display?
    !!blog
  end
  
  def title
    blog.title
  end

  def text
    blog.summary
  end
end
