class Competition < ActiveRecord::Base
  belongs_to :state, :class_name => 'CompetitionState'
  has_many :entries, :dependent => :delete_all
  
  # check if the competition reached deadline. if so, update the state
  def reached_deadline?
    Time.now > self.deadline_on
  end
    
  def open?
    self.state == CompetitionState.find_by_name("open")
  end
  
  def closed?
    self.state == CompetitionState.find_by_name("closed")
  end
end