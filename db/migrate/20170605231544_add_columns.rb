class AddColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :residents, :age, :integer
    add_column :residents, :birthdate, :date
    remove_column :volunteers, :age, :integer
    add_column :volunteers, :birthdate, :date
  end
end
