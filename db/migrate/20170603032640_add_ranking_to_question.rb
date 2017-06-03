class AddRankingToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :ranking, :integer
  end
end
