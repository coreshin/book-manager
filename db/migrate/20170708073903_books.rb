class Books < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.references :user
      t.string :title
      t.string :author
      t.boolean :star
      t.date :date
      t.integer :rate
      t.timestamps  null: false
    end
  end
end