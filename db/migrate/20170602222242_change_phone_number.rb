class ChangePhoneNumber < ActiveRecord::Migration[5.0]
  def change
    remove_column :organizations, :phone_number, :integer
    remove_column :residents, :phone_number, :integer
    remove_column :volunteers, :phone_number, :integer
    add_column :organizations, :phone_number, :string
    add_column :residents, :phone_number, :string
    add_column :volunteers, :phone_number, :string
  end
end
