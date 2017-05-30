class CreateVolunteers < ActiveRecord::Migration[5.0]
  def change
    create_table :volunteers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :email
      t.integer :phone_number

      t.timestamps
    end
  end
end
