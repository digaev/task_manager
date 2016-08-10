class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :user
      t.string :name, null: false
      t.string :description
      t.string :state
      t.timestamps
    end
  end
end
