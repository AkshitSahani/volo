class RemoveExtrasFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :age, :string
    remove_column :users, :phone_number, :integer
    remove_column :users, :location_id, :integer
    remove_column :residents, :first_name, :string
    remove_column :residents, :last_name, :string
    remove_column :residents, :email, :string
    remove_column :volunteers, :first_name, :string
    remove_column :volunteers, :last_name, :string
    remove_column :volunteers, :email, :string
    remove_column :organizations, :name, :string
    remove_column :organizations, :email, :string
    add_column :volunteers, :user_id, :integer
    add_column :organizations, :user_id, :integer
    add_column :residents, :user_id, :integer
  end
end
