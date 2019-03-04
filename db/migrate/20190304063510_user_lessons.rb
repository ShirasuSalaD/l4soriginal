class UserLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_lessons do |t|
      t.integer :user_id #ユーザーID
      t.integer :lesson_id #講義ID
      t.timestamps null:false
    end
  end
end
