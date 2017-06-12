class RemovePhoneFromMultiples < ActiveRecord::Migration[5.0]
  def change
    remove_column :residents, :phone_number, :string
    remove_column :organizations, :phone_number, :string
  end
end
