# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "Jacek Admin",
             email: "admin@myplan.com",
             password: "12345",
             password_confirmation: "12345",
             activated: true,
             activated_at: Time.zone.now,
             admin: true)

5.times do |n|
  name  = "User-#{n+1}"
  email = "user-#{n+1}@myplan.com"
  User.create!(name: name,
               email: email,
               password: "12345",
               password_confirmation: "12345",
               activated: true,
               activated_at: Time.zone.now)
end

# Create microposts
users = User.all
5.times do |n|
  content = "Hello world number #{n}"
  users.each { |user| user.microposts.create!(content: content)}
end 
