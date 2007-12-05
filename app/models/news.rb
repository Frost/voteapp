class News < ActiveRecord::Base
  has_many :news_comments
  validates_presence_of :title
  validates_presence_of :news_text
end
