class Entry < ActiveRecord::Base
  has_many :votes
  
  belongs_to :competition
  belongs_to :user
  belongs_to :state, :class_name => 'EntryState'
  
  file_column :thumbnail, :magick => { :geometry => "150x150>" }
  
  file_column :filename
  
  validate :validate_extensions
  
  validates_presence_of :name, :description
  
  VALID_THUMBNAIL_EXTENSIONS = ["png", "jpg", "jpeg", "gif"]
  VALID_FILENAME_EXTENSIONS = ["zip", "rar", "bz2", "gz", "tar", "tgz"]
  
  def user
    return User.find(self.user_id)
  end
  
  def viewable? 
    
  end
  
  def editable?
    
  end
  
  def total_votes 
    total = 0
    self.votes.each do |e|
      total = total + e.rating unless e.rating.nil?
    end
    return total
  end
  
  def valid_votes
    total = 0
    
    # filtrera ut alla voters som inte är registrerade besökare
    self.votes.select {|v| User.find(v.user_id).status == "user"}.each do |e|
      total = total + e.rating if e.rating != nil 
    end

    return total
  end
  
  def number_of_valid_votes
    return self.votes.select {|v| User.find(v.user_id).status == "user"}.length
  end
  
  private 
  def validate_extensions
    if not filename.nil?
      ext = filename.split(".").last
      if not VALID_FILENAME_EXTENSIONS.include? ext
        errors.add("filename must use one of the following extensions: " + 
            VALID_FILENAME_EXTENSIONS.join(", "))
      end
    end
    
    if not thumbnail.nil?
       ext = thumbnail.split(".").last
       if not VALID_THUMBNAIL_EXTENSIONS.include? ext
         errors.add("thumbnail must use one of the following extensions: " + 
             VALID_THUMBNAIL_EXTENSIONS.join(", "))
       end
     end
  end
end