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

class FeedEntry < ActiveRecord::Base
  class TargetTypeMismatch < StandardError; end
  class FeatureNotImplemented < StandardError; end
  
  has_many :feed_entry_profiles
  has_many :profiles, :through => :feed_entry_profiles, :uniq => true
  
  class << self
    def create_from(record, type = nil)
      klass = "FeedEntry::#{type || record.class.class_name}".constantize
      raise TargetTypeMismatch unless klass.acceptable?(record)
      o = klass.new(:ref_id => record.id)
      o.set_associated if o.respond_to?(:set_associated)
      o.can_be_grouped? ? o.group : o.save!
    end
    
    def can_be_grouped?
      false
    end
    
    def acceptable?
      false
    end
  end
  
  def acceptable?
    self.class.acceptable?
  end
  
  def group
    raise FeatureNotImplemented
  end
  
  def can_be_grouped?
    self.class.can_be_grouped?
  end
  
end
