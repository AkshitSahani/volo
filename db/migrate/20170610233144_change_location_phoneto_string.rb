class ChangeLocationPhonetoString < ActiveRecord::Migration[5.0]
  def change
    remove_column :locations, :phone_number, :integer
    add_column :locations, :phone_number, :string
    remove_column :locations, :volunteer_coordinator_phone, :integer
    add_column :locations, :volunteer_coordinator_phone, :string
  end
end
