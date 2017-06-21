class RemoveFieldsFromVolunteers < ActiveRecord::Migration[5.0]
  def change
    remove_column :volunteers, :birthdate, :integer
    remove_column :volunteers, :phone_number, :integer
    remove_column :residents, :birthdate, :integer
  end
end
