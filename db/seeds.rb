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
Survey.delete_all
Question.delete_all
AnswerSet.delete_all

50.times do User.create!(
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
  user_id: rand(1..10),
  name: Faker::Company.name
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
  v = Volunteer.create!(
  age: rand(20..60),
  user_id: volunteer_counter,
  phone_number: "1234567890"
  )
  location_counter = 1
  10.times do
    v.locations << Location.find(location_counter)
    location_counter += 1
  end
  volunteer_counter += 1
end

resident_counter = 11
10.times do
  r = Resident.create!(
  age: rand(60..110),
  user_id: resident_counter,
  phone_number: "1234567890"
  )
  resident_counter += 1
  r.location = Location.find(rand(1..10))
end

survey_counter = 1
20.times do
  Survey.create!(
    name: "The humble beginnings of a great survey ##{survey_counter}",
    location_id: rand(1..10)
  )
  survey_counter += 1
end

open_question_set = ["Why do you want to volunteer?", "Why do you want to volunteer at Schelegel Villages?", "Tell us more about yourself"]
open_response_set = ["I love volunteering.", "I want to help out in my community.", "I want to give back."]

question_counter = 1
survey_counter = 1
20.times do
  Question.create!(
    question: open_question_set.sample,
    survey_id: survey_counter,
    question_type: "Open Response",
    ranking: 20
  )
  volunteer_counter = 1
  10.times do
    Response.create!(
      question_id: question_counter,
      volunteer_id: volunteer_counter,
      response: open_response_set.sample
    )
    volunteer_counter += 1
  end
  resident_counter = 1
  10.times do
    Response.create!(
      question_id: question_counter,
      resident_id: resident_counter,
      response: "N/A"
    )
    resident_counter += 1
  end
  question_counter += 1
  survey_counter += 1
end

20.times do
  Question.create!(
    question: "What languages do you speak?",
    survey_id: rand(1..20),
    question_type: "Multiple Choice",
    ranking: rand(1..100)
  )
end

20.times do
  Question.create!(
    question: "How old are you?",
    survey_id: rand(1..20),
    question_type: "Drop-Down",
    ranking: rand(1..100)
  )
end

question_counter = 21
language_options = ["English", "French", "Spanish"]

20.times do
  option_counter = 0
  3.times do
    AnswerSet.create!(
      question_id: question_counter,
      answer: language_options[option_counter]
    )
    option_counter += 1
  end
  volunteer_counter = 1
  10.times do
    Response.create!(
      question_id: question_counter,
      volunteer_id: volunteer_counter,
      response: Question.find(question_counter).answer_sets.sample.id
    )
  volunteer_counter += 1
  end
  resident_counter = 1
  10.times do
    Response.create!(
      question_id: question_counter,
      resident_id: resident_counter,
      response: Question.find(question_counter).answer_sets.sample.id
    )
    resident_counter += 1
  end
  question_counter += 1
end

age_options = (1...100).to_a

20.times do
  option_counter = 0
  100.times do
    AnswerSet.create!(
      question_id: question_counter,
      answer: age_options[option_counter]
    )
    option_counter += 1
  end
  volunteer_counter = 1
  10.times do
    Response.create!(
    question_id: question_counter,
    response: Question.find(question_counter).answer_sets.sample.id,
    volunteer_id: volunteer_counter
    )
    volunteer_counter += 1
  end
  resident_counter = 1
  10.times do
    Response.create!(
    question_id: question_counter,
    response: Question.find(question_counter).answer_sets.sample.id,
    volunteer_id: resident_counter
    )
    resident_counter += 1
  end
  question_counter += 1
end
