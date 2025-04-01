# == Schema Information
#
# Table name: courses
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country    :string
#  city       :string
#
class Course < ApplicationRecord
  has_many :links, -> { order(position: :asc) }, class_name: "Course::Link", inverse_of: :course
  accepts_nested_attributes_for :links

  def has_skills
    true
  end

  def has_skills=(value)
    true
  end

  def skill_suggestions
    ["example suggestion", "example tag", name]
  end

  def skill_disallowed
    ["foo", "bar", id]
  end

  def self.countries
    ["USA", "Japan", "Spain", "Thailand"]
  end

  def self.cities
    {
      USA: ["New York", "Los Angeles", "San Francisco", "Boston", "Philadelphia"],
      Japan: ["Tokyo", "Osaka", "Kyoto", "Hiroshima", "Yokohama", "Nagoya", "Kobe"],
      Spain: ["Madrid", "Valencia", "Barcelona"],
      Thailand: ["Chiang Mai", "Bangkok", "Phuket"]
    }
  end

  def self.ransackable_attributes(auth_object = nil)
    ["city", "country", "created_at", "id", "name", "skills", "updated_at"]
  end
end
