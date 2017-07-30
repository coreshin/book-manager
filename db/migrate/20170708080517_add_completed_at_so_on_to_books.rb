class AddCompletedAtSoOnToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :rate, :integer
  end
end
