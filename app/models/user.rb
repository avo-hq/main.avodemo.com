class User < ApplicationRecord
  extend FriendlyId
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :posts
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :teams, join_table: :team_memberships

  has_one_attached :cv

  friendly_id :name, use: :slugged

  scope :active, -> { where active: true }
  scope :admins, -> { where "(roles->>'admin')::boolean is true" }
  scope :non_admins, -> { where "(roles->>'admin')::boolean != true" }

  def admin?
    roles.present? and roles['admin'] === true
  end

  def name
    "#{first_name} #{last_name}"
  end

  def notify(text)
    # notify about text
  end

  def avatar
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80'
  end

  def avo_title
    'Admin'
  end
end
