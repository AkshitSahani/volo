# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Organization.delete_all
Location.delete_all
Volunteer.delete_all
Resident.delete_all

20.times do User.create!(
    user_type: ['Resident','Volunteer','Organization'].sample,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'topsecret',
    password_confirmation: 'topsecret'
  )
end

10.times do Organization.create!(
  location: Faker::Address.street_address,
  phone_number: "1234567890",
  user_id: rand(1..10)
  )
end

10.times do Location.create!(
  branch_name: Faker::Company.name ,
  address:  Faker::Address.street_address,
  phone_number: "1234567890",
  volunteer_coordinator_name: Faker::Name.name,
  volunteer_coordinator_phone: "1234567890",
  organization_id: rand(1..10)
)
end

volunteer_counter = 1
10.times do
  Volunteer.create!(
  age: rand(20..60),
  user_id: volunteer_counter,
  phone_number: "1234567890"
  )
  volunteer_counter += 1
end

resident_counter = 11
10.times do
  Resident.create!(
  age: rand(60..110),
  user_id: resident_counter,
  phone_number: "1234567890"
  )
  resident_counter += 1
end
