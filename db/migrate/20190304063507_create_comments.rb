class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :comment #コメント
      t.integer :star #評価
      t.integer :user_id #ユーザーID
      t.integer :lesson_id #講義ID
      t.timestamps null:false
    end
  end
end
