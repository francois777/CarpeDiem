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

  factory :accommodation_type do
    accom_type 'A'
    description 'Tent Site Without Power'
    show true
    show_normal_price true
    show_in_season_price true
    show_promotion true
  end

  factory :tariff do
    tariff_category "B2"
    tariff 9000
    with_power_points true
    season_class 'in_season_tariff'
    effective_date Date.today - 300
    end_date Date.today + 300
    association :accommodation_type
  end

  factory :event do
    title 'Annual Staff Reunion'
    organiser_name 'Victor Korestensky'
    organiser_telephone '08 6511 1122'
    start_date Date.today + 30
    end_date Date.today + 34
    confirmed true
    estimated_guests_count 20
    estimated_chalets_required 2
    estimated_sites_required 3
    power_required true
    meals_required true
    quoted_cost 35000
    comments 'Will confirm in two weeks'
  end  


end


