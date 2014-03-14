FactoryGirl.define do

  factory :user do
    name "Donald Duck"
    email "donald@duck.com"
    password "secret"
    password_confirmation "secret"
  end

end
