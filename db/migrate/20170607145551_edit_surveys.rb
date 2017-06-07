class EditSurveys < ActiveRecord::Migration[5.0]
  def change
    remove_column :surveys, :location_id, :integer
    add_column :surveys, :organization_id, :integer
  end
end
