class CreateFoo < ActiveRecord::Migration[7.2]
  def change
    create_table :foo do |t|
      t.string :bar

      t.timestamps
    end
  end
end
