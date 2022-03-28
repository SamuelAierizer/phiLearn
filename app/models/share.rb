class Share < ApplicationRecord
  belongs_to :shareable, polymorphic: true

  enum shareable_type: {'Event': 1}
end