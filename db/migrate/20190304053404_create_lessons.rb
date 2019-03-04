class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.string :lesson #講義名
      t.string :teacher #講師
      t.string :faculty #学部
      t.string :term #学期
      #とりあえずここまで
      t.timestamps null:false
    end
  end
end
