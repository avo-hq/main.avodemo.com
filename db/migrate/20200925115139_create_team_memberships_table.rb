class CreateTeamMembershipsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :team_memberships do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :level

      t.timestamps
    end
  end
end
