class AddCompletedAtSoOnToBooks3 < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :date, :date
  end
end
