class RemoveAnswerSetToQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :answer_set, :string
  end
end
