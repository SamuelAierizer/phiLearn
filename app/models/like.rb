class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true

  enum likeable_type: {'Post': 1, 'Topic': 2 }
end