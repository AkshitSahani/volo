class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :question
      t.integer :survey_id
      t.string :question_type

      t.timestamps
    end
  end
end
