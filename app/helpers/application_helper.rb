# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def item_by(item, user)
    if item.methods.include? "user"
      if user.is_a? Integer
        user = User.find(user)
      end
      
      return item.user == user
    end
  end
  
  def pluralize(length, sentense1, sentense2) 
    if length == 1
      return sentense1
    else 
      return sentense2 % [length]
    end
  end 
  
  def textilize(text)
    RedCloth.new(text).to_html
  end
  
end