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

20.times do
  User.create!(
    user_type: 'Volunteer',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'topsecret',
    password_confirmation: 'topsecret',
    phonenumber: "1234567890",
    birthdate: rand(Date.civil(1940, 1, 1)..Date.civil(1990, 12, 31))
  )
end

30.times do
  User.create!(
    user_type: 'Resident',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '123456',
    password_confirmation: '123456',
    phonenumber: "1234567890",
    birthdate: rand(Date.civil(1940, 1, 1)..Date.civil(1990, 12, 31))
  )
end

1.times do
  User.create!(
    user_type: 'Organization',
    first_name: "Schlegel Villages",
    email: 'schlegel.villages@gmail.com',
    password: '123456',
    password_confirmation: '123456',
    phonenumber: "1234567890"
  )
end

organization_counter = 51
1.times do
  Organization.create!(
    address: '325 Max Becker Dr., Kitchener, ON, N2E 4H5',
    user_id: organization_counter,
    name: User.find(organization_counter).first_name
  )
  organization_counter += 1
end

branch_names = [['Coleman Care Center', '140 Cundles Road West L4N 9X8 ON'],['The Village of Sandalwood Park', '425 Great Lakes Drive L6R 2W8 ON'], ['The Village of Tansley Woods', '4100 Upper Middle Road L7M 4W8 ON'], ['The Village of Humber Heights', '2245 Lawrence Avenue West M9P 3W3 ON'], ['The Village of Riverside Glen', '60 Woodlawn Road East N1H 8M8 ON']]

branch_counter = 0
5.times do
  Location.create!(
    branch_name: branch_names[branch_counter][0],
    address:  branch_names[branch_counter][1],
    phone_number: "705-726-8691",
    volunteer_coordinator_name: Faker::Name.name,
    volunteer_coordinator_phone: "416-111-2222",
    organization_id: 1
  )
  branch_counter += 1
end

survey_counter = 1
3.times do
  org = Organization.find(1)
  s = Survey.create!(
    name: "Volo Survey #{survey_counter}",
    organization_id: org.id
    )
  s.locations << org.locations.sample
  survey_counter += 1
end

open_question_set = ["Why do you want to volunteer?", "Why do you want to volunteer at Schelegel Villages?", "Tell us more about yourself"]
open_response_set = ["I love volunteering.", "I want to help out in my community.", "I want to give back."]

survey_counter = 1
3.times do
  Question.create!(
    question: open_question_set.sample,
    survey_id: survey_counter,
    question_type: "Open Response Question",
    ranking: 20
  )
  survey_counter += 1
end

survey_counter = 1
3.times do
  Question.create!(
    question: "What languages do you speak?",
    survey_id: survey_counter,
    question_type: "Multiple Choice Question",
    ranking: rand(1..100)
  )
  survey_counter += 1
end

survey_counter = 1
3.times do
  Question.create!(
    question: "What are your expectations in terms of training and supervision?",
    survey_id: survey_counter,
    question_type: "Drop-Down Question",
    ranking: rand(1..100)
  )
survey_counter += 1
end

volunteer_counter = 1
20.times do
  v = Volunteer.create!(
    user_id: volunteer_counter
  )
  location_counter = rand(1..2)
  2.times do
    v.locations << Location.find(location_counter)
    location_counter += rand(1..3)
  end
  volunteer_counter += 1
end

resident_counter = 21
30.times do
  Resident.create!(
    user_id: resident_counter,
    location_id: Location.find(rand(1..5)).id
  )
  resident_counter += 1
end

language_options = ["English", "French", "Spanish", "Mandarin", "Cantonese", "Filipino", "Thai", "Vietnamese"]

question_counter = 4
3.times do
  option_counter = 0
  8.times do
    AnswerSet.create!(
      question_id: question_counter,
      answer: language_options[option_counter]
    )
    option_counter += 1
  end
  question_counter += 1
end

expectation_options = ["Working independently", "Working with another volunteer", "Working with a staff member", "All of the above"]

3.times do
  option_counter = 0
  4.times do
    AnswerSet.create!(
      question_id: question_counter,
      answer: expectation_options[option_counter]
    )
    option_counter += 1
  end
  question_counter += 1
end

volunteers = Volunteer.all

volunteers.each do |v|
  locations = v.locations
  surveys = []
  locations.each do |l|
    l.surveys.each do |s|
      surveys.push(s)
    end
  end
  questions = []
  surveys.each do |s|
    s.questions.each do |q|
      questions.push(q)
    end
  end
  questions.each do |q|
    if q.question_type == "Open Response Question"
      Response.create!(
        question_id: q.id,
        volunteer_id: v.id,
        response: open_response_set.sample
      )
    elsif q.question_type == "Multiple Choice Question"
      rand1 = rand(1..7)
      rand2 = rand1 - 1
      Response.create!(
        question_id: q.id,
        volunteer_id: v.id,
        response: "#{q.answer_sets.to_a[rand1].answer}, #{q.answer_sets.to_a[rand2].answer}"
      )
    elsif q.question_type == "Drop-Down Question"
      Response.create!(
        question_id: q.id,
        volunteer_id: v.id,
        response: q.answer_sets.sample.answer
      )
    end
  end
end


residents = Resident.all

residents.each do |r|
  surveys = r.location.surveys
  questions = []
  surveys.each do |s|
    s.questions.each do |q|
      questions.push(q)
    end
  end
  questions.each do |q|
    if q.question_type == "Open Response Question"
      Response.create!(
        question_id: q.id,
        resident_id: r.id,
        response: "N/A"
      )
    elsif q.question_type == "Multiple Choice Question"
      rand1 = rand(1..7)
      rand2 = rand1 - 1
      Response.create!(
        question_id: q.id,
        resident_id: r.id,
        response: "#{q.answer_sets.to_a[rand1].answer}, #{q.answer_sets.to_a[rand2].answer}"
      )
    elsif q.question_type == "Drop-Down Question"
      Response.create!(
        question_id: q.id,
        resident_id: r.id,
        response: q.answer_sets.sample.answer
      )
    end
  end
end
