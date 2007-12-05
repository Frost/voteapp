module CompetitionHelper
  def entry_in_competition?(competition)
    if not session[:user_id]
      return false
    end
    user_entries = User.find(session[:user_id]).entries
    
    user_entries.each { |entry| return true if entry.competition == competition }
    
    return false
  end
  
  def approved_entries(competition)
    competition.entries.select {|e| e.state == EntryState.find_by_name("approved")}
  end
end