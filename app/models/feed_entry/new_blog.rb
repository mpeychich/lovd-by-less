class FeedEntry::NewBlog < FeedEntry
  
  class << self
    def acceptable?(record)
      record.is_a?(Blog)
    end
    
    def group_on_for(record)
      record.profile
    end
    
    def conditions_for(record)
      ["group_on_type = ? and group_on_id = ? and type = ? and created_at >= ?", 'Profile', record.profile_id, 'NewBlog', Date.today-1.day]
    end
    
    def partial
      'new_blog'
    end
  end
  
  
  
  def title
    ref_obj.title
  end

  def text
    ref_obj.summary
  end
end
