class Ticket < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: {message: "must have title"}, uniqueness: true
  validates_presence_of :body, message: "must be present"
  default_scope{ order("created_at DESC") }
  before_save :capitalize_title

  def capitalize_title
    self.title.capitalize!
  end
end
