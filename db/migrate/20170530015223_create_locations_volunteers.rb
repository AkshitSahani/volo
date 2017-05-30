class CreateLocationsVolunteers < ActiveRecord::Migration[5.0]
  def change
    create_table :locations_volunteers do |t|
      t.integer :location_id
      t.integer :volunteer_id
    end
  end
end
