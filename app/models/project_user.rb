# == Schema Information
#
# Table name: projects_users
#
#  id         :bigint           not null, primary key
#  project_id :bigint
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProjectUser < ApplicationRecord
  self.table_name = 'projects_users'
end
