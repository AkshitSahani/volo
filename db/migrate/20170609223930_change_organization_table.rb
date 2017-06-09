class ChangeOrganizationTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :organizations, :location, :address
    remove_column :organizations, :name, :string
  end
end
