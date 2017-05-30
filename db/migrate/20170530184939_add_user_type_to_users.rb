class AddUserTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_type, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :age, :string
    add_column :users, :phone_number, :integer
    add_column :users, :location_id, :integer
  end
end
