# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create admin
User.create!(name: "Jacek",
             email: "admin@myplan.com",
             password: "12345",
             password_confirmation: "12345",
             activated: true,
             activated_at: 10.days.ago,
             admin: true)

# Create users
40.times do |n|
  name  = Faker::Name.first_name
  email = Faker::Internet.email
  avatar_array = ["one.png", "two.png", "three.png", "four.png", "five.png"]
  User.create!(name: name,
               email: email,
               password: "12345",
               password_confirmation: "12345",
               activated: true,
               activated_at: n.hours.ago)
end

# Create microposts
users = User.order(:created_at).take(7)
10.times do |n|
  content = Faker::Lorem.sentence(4)
  users.each { |user| user.microposts.create!(content: content)}
end 

# Following relationships
users = User.all
user  = users.first
following = users[2..35]
followers = users[3..30]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }