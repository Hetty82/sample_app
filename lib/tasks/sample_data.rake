namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(
      name: "Mickey Mouse",
      email: "mickey@mouse.com",
      password: "secret",
      password_confirmation: "secret"
    )
    99.times do |n|
      name = Faker::Name.name
      email = Faker::Internet.email
      password = "secret"
      User.create!(
        name: name,
        email: email,
        password: password,
        password_confirmation: password
      )
    end
  end
end
