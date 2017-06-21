class RemoveImageFromUsers < ActiveRecord::Migration[5.0]
  def change
    # remove_column :users, :image, :attachment
  end
  def up
    add_attachment :users, :avatar
  end
  def down
    remove_attachment :users, :avatar
  end
end
