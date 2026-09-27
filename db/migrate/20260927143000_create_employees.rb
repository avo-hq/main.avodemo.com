# Backs the Employee demo resource: a record with fields the policy withholds, so field
# authorization (avo-authorization 4.2.1) can be checked live on every surface.
class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :department
      t.integer :salary
      t.string :ssn
      t.integer :performance_rating
      t.date :hired_on
      t.text :notes

      t.timestamps
    end
  end
end
