class AddCommentsCountToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :comments_count, :integer, null: false, default: 0
  end
end
