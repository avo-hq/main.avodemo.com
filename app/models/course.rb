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

  # Notify admins whenever a course is created, updated, or destroyed. Uses
  # *_commit so notifications only fire after the DB transaction succeeds.
  after_create_commit  { notify_admins("Course created",   "“#{name}” was created.",   :success, course_url) }
  after_update_commit  { notify_admins("Course updated",   "“#{name}” was updated.",   :info,    course_url) }
  after_destroy_commit { notify_admins("Course destroyed", "“#{name}” was destroyed.", :warning) }

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

  # Enables the `links_link` dynamic filter (query_attributes: [:links_link]) on
  # the Course resource's has_many :links field.
  def self.ransackable_associations(auth_object = nil)
    ["links"]
  end

  def course_url
    "#{Avo.configuration.root_path}/resources/courses/#{id}"
  end

  private

  def notify_admins(title, body, level, url = nil)
    # NOTE: pass an Array, not a Relation — avo-notifications 4.0.0.alpha.1's
    # resolve_recipients only special-cases Array/:all and would otherwise wrap
    # the whole relation as a single recipient.
    recipients = User.admins.to_a
    return if recipients.blank?

    Avo::Notifications.send(
      to: recipients,
      title: title,
      body: body,
      level: level,
      url: url,
      notification_type: "course"
    )
  end
end
