# == Schema Information
#
# Table name: teams
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  url         :string
#
class Team < ApplicationRecord
  has_prefix_id :team
  validates :name, presence: true

  has_many :memberships, class_name: 'TeamMembership', foreign_key: :team_id, inverse_of: :team
  has_many :team_members, through: :memberships, source: :user

  has_one :admin_membership, -> { where 'team_memberships.level' => :admin }, class_name: 'TeamMembership', dependent: :destroy
  has_one :admin, through: :admin_membership, source: :user, inverse_of: :teams

  has_many :reviews, as: :reviewable

  def self.ransackable_attributes(auth_object = nil)
    ["color", "created_at", "description", "id", "name", "updated_at", "url"]
  end
end
