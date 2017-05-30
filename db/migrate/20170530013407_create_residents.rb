class CreateResidents < ActiveRecord::Migration[5.0]
  def change
    create_table :residents do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :email
      t.integer :location_id

      t.timestamps
    end
  end
end
