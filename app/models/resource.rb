class Resource < ApplicationRecord
  belongs_to :material, polymorphic: true
  enum material_type: {'Course': 1, 'Lecture': 2, 'Assignment': 3}

  scope :get_for, -> (type, id) { where(material_type: type, material_id: id) }
end
