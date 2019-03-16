require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'csv'

CSV.foreach('db/seeds/lessons_test.csv') do |row|
  Lesson.create(
    # user_id: row[2],
    lesson: row[1], #講義名
    teacher: row[3], #講師
    faculty: row[0], #学部
    term: row[5] #学期
    #とりあえずここまで
  )
end