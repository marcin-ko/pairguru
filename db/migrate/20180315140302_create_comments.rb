class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false, index: true
      t.references :commenter, polymorphic: true, null: false, index: true
      t.text :text

      t.timestamps
    end
  end
end
