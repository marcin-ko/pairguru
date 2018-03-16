class AddMoviesCountToGenre < ActiveRecord::Migration[5.1]
  def change
    add_column :genres, :movies_count, :integer, null: false, default: 0
  end
end
