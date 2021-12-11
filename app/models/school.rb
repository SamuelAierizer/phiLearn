class School < ApplicationRecord
  has_many :users, inverse_of: :school, :dependent => :destroy
  has_one :forum, as: :forumable, :dependent => :destroy

end
