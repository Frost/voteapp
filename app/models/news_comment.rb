class NewsComment < ActiveRecord::Base
  belongs_to :news
  validates_presence_of :comment_text
end
