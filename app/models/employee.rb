# Field authorization demo. See EmployeePolicy for which fields each surface withholds.
class Employee < ApplicationRecord
  validates :name, presence: true
end
