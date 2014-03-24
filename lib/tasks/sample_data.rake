namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(
      name: "Mickey Mouse",
      email: "mickey@mouse.com",
      password: "secret",
      password_confirmation: "secret"
    )
    admin.toggle! :admin

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

    users = User.all(limit: 6)
    15.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end
