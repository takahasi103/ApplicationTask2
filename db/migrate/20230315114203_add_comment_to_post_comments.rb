class AddCommentToPostComments < ActiveRecord::Migration[6.1]
  def change
    add_column :post_comments, :comment, :text
  end
end
