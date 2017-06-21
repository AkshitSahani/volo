class RemovePhonenumberFromOrganizations < ActiveRecord::Migration[5.0]
  def change
    remove_column :organizations, :phone_number, :string
  end
end
