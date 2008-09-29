# == Schema Information
# Schema version: 2
#
# Table name: blogs
#
#  id         :integer(11)   not null, primary key
#  title      :string(255)   
#  body       :text          
#  profile_id :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Blog < ActiveRecord::Base
  has_many :comments, :as => :commentable, :order => "created_at asc"
  belongs_to :profile
  validates_presence_of :title, :body
  
  def after_create
    f = FeedEntry::NewBlog.create_from(self)
    ([profile] + profile.friends + profile.followers).each{ |p| p.feed_items << f }
  end
  
  
  def to_param
    "#{self.id}-#{title.to_safe_uri}"
  end
  
  def summary
    body.truncate(60)
  end
end
