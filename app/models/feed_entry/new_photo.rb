class FeedEntry::NewPhoto < FeedEntry
  
  class << self
    def acceptable?(record)
      record.is_a?(Photo)
    end
    
    def can_be_grouped?
      true
    end
    
    def group_on_for(record)
      record.profile
    end
    
    def conditions_for(record)
      ["group_on_type = ? and group_on_id = ? and type = ? and created_at >= ?", 'Profile', record.profile_id, 'NewPhoto', Date.today-1.day]
    end
    
    def partial
      'new_photo'
    end
  end
  
  
  
  def title
    "New Photo"
  end

  def text
    if count == 1
      "#{ref_obj.profile.f rescue 'anonymous'} has uploaded a new photo."
    else
      "#{ref_obj.profile.f rescue 'anonymous'} has uploaded #{count} new photos."
    end
  end
end
