class CreateLocationsSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :locations_surveys do |t|
      t.integer :location_id
      t.integer :survey_id
    end
  end
end
