class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.string :response
      t.integer :question_id
      t.integer :resident_id
      t.integer :volunteer_id

      t.timestamps
    end
  end
end
