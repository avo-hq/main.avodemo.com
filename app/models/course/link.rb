# == Schema Information
#
# Table name: course_links
#
#  id         :bigint           not null, primary key
#  link       :string
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#
class Course::Link < ApplicationRecord
  belongs_to :course

  acts_as_list
  default_scope -> { order(position: :asc, created_at: :desc) }

  # Notify admins when a link is attached to / detached from a course. Uses
  # *_commit so notifications only fire after the DB transaction succeeds.
  after_create_commit do
    notify_admins("Course link attached", "#{link} was attached to “#{course.name}”.", :info, course.course_url)
  end
  after_destroy_commit do
    notify_admins("Course link detached", "#{link} was detached from “#{course.name}”.", :warning, course.course_url)
  end

  def self.table_name_prefix
    'course_'
  end

  def self.ransackable_attributes(auth_object = nil)
    ["course_id", "created_at", "id", "link", "position", "updated_at"]
  end

  # Enables the `course_name` dynamic filter (query_attributes: [:course_name])
  # on the CourseLink resource's belongs_to :course field.
  def self.ransackable_associations(auth_object = nil)
    ["course"]
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
      notification_type: "course_link"
    )
  end
end
