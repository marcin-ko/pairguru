class AddDiscardToComments < ActiveRecord::Migration[5.1]
  def up
    add_column :comments, :discarded_at, :datetime
    add_index :comments, :discarded_at
  end
end
