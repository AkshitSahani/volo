class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :branch_name
      t.string :address
      t.integer :phone_number
      t.string :volunteer_coordinator_name
      t.integer :volunteer_coordinator_phone
      t.integer :organization_id

      t.timestamps
    end
  end
end
