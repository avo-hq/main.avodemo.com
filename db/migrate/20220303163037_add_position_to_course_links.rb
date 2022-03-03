class AddPositionToCourseLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :course_links, :position, :integer
  end
end
