# Backs the Unauthorized model, whose only job is to sit behind a deny-all
# policy so we can watch Avo hide a resource. The table stays empty in practice
# -- UnauthorizedPolicy::Scope resolves to `none` -- but it has to exist, or
# anything that touches the model raises instead of being refused.
class CreateUnauthorizeds < ActiveRecord::Migration[8.1]
  def change
    create_table :unauthorizeds do |t|
      t.string :name

      t.timestamps
    end
  end
end
