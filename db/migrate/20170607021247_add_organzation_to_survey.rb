class AddOrganzationToSurvey < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :organization_id, :integer
  end
end
