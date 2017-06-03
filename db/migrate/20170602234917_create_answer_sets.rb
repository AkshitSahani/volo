class CreateAnswerSets < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_sets do |t|

      t.timestamps
    end
  end
end
