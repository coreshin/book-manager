class AddCompletedAndSoOnToBooks5 < ActiveRecord::Migration[5.1]
  def change
    remove_column :books, :author, :sting
    add_column :books, :author, :string
  end
end
