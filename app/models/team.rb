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
  validates :name, presence: true

  has_many :memberships, class_name: 'TeamMembership', foreign_key: :team_id, inverse_of: :team
  has_many :team_members, through: :memberships, source: :user

  has_one :admin_membership, -> { where 'team_memberships.level' => :admin }, class_name: 'TeamMembership', dependent: :destroy
  has_one :admin, through: :admin_membership, source: :user

  has_many :reviews, as: :reviewable
end
