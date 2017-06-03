class AddAnswerSetToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :answer_set, :string
  end
end
