class AddFieldsToAnswerSet < ActiveRecord::Migration[5.0]
  def change
    add_column :answer_sets, :question_id, :integer
    add_column :answer_sets, :answer, :string
  end
end
