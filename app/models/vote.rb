class Vote < ActiveRecord::Base
  belongs_to :entry
  has_one :user
  validates_uniqueness_of :user_id, :on => :create, :scope => :entry_id, :message => "must be unique"
  #validates_uniqueness_of :ip, :scope => :entry_id
  
  def user
    User.find(self.user_id)
  end
end
