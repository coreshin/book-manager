class AddIdListToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :list_id, :interger, default: 1 
  end
end
