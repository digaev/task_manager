class AddAttachmentToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :attachment, :string
  end
end
