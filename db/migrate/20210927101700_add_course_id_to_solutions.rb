class AddCourseIdToSolutions < ActiveRecord::Migration[6.1]
  def change
    add_reference :solutions, :course
  end
end
