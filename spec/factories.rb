FactoryGirl.define do

  factory :user do
    sequence(:first_name)  { |n| "Called_#{n}" }
    last_name "Last Name"
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
end