class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :authentication
      t.string :like

      t.timestamps
    end
  end
end
