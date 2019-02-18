class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.belongs_to :author, foreign_key: { to_table: :users }
      t.belongs_to :commentable, polymorphic: true
      t.text :body
      
      t.timestamps
    end
  end
end
