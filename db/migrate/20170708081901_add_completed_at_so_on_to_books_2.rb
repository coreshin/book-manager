class AddCompletedAtSoOnToBooks2 < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :comment, :text
  end
end
