class RemovePhonenumberFromOrganizations < ActiveRecord::Migration[5.0]
  def change
    remove_column :organizations, :phonenumber, :string
  end
end
