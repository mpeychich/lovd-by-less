# == Schema Information
# Schema version: 20080919221242
#
# Table name: comments
#
#  id               :integer(11)   not null, primary key
#  comment          :text          
#  created_at       :datetime      not null
#  updated_at       :datetime      not null
#  profile_id       :integer(11)   
#  commentable_type :string(255)   default(""), not null
#  commentable_id   :integer(11)   not null
#  is_denied        :integer(11)   default(0), not null
#  is_reviewed      :boolean(1)    
#

class Comment < ActiveRecord::Base
  
  validates_presence_of :comment, :profile
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :profile

  def after_create
    FeedEntry.create(self)
  end
  
  
  def self.between_profiles profile1, profile2
    find(:all, {
      :order => 'created_at desc',
      :conditions => [
        "(profile_id=? and commentable_id=?) or (profile_id=? and commentable_id=?) and commentable_type='Profile'",
        profile1.id, profile2.id, profile2.id, profile1.id]
    })
  end
end
