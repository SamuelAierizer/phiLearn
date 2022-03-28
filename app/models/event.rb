class Event < ApplicationRecord
  has_rich_text :description

  belongs_to :user

  has_many :shares, as: :shareable, dependent: :destroy

  
  validates :title, :start, presence: true
  validates :description, length: {maximum: 1000}

  enum color: {"blue-500": 0, "red-500": 1, "green-500": 2, "yellow-500": 3, "indigo-500": 4, "gray-500": 5, "black": 6}

  def getFinish
    if self.finish.nil?
      self.start
    else 
      self.finish
    end
  end

end
