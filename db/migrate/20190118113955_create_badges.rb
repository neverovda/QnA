class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.string :name
      t.belongs_to :badgeable, polymorphic: true
      t.references :question, foreign_key: true
            
      t.timestamps
    end
  end
end
