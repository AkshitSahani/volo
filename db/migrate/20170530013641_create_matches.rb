class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.integer :volunteer_id
      t.integer :resident_id
      t.integer :match_score

      t.timestamps
    end
  end
end
