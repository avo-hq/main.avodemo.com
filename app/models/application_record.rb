class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # `ransackable_attributes` by default returns all column names
  # and any defined ransackers as an array of strings.
  # For overriding with a whitelist array of strings.
  #
  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  # `ransackable_associations` by default returns the names
  # of all associations as an array of strings.
  # For overriding with a whitelist array of strings.
  #
  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end
end
