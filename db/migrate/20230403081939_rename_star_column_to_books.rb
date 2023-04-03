class RenameStarColumnToBooks < ActiveRecord::Migration[6.1]
  def change
    rename_column :books, :star, :score
  end
end
