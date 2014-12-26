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

  factory :diary_day do
    sequence(:day) { |n| Date.today + n }
    diarisable { Event.first || create(:event) }
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
    effective_date Date.today - 300
    end_date Date.today + 300
    price_class 0
    association :accommodation_type
  end

  factory :event do
    title 'Annual Staff Reunion'
    organiser_name 'Victor Korestensky'
    organiser_telephone '08 6511 1122'
    start_date (Date.today + 30)
    end_date (Date.today + 34)
    confirmed true
    estimated_guests_count 20
    estimated_chalets_required 2
    estimated_sites_required 3
    power_required true
    meals_required true
    quoted_cost 35000
    comments 'Will confirm in two weeks'
  end  

  factory :chalet do
    name 'Simeon'
    location_code 'A12'
    style_class 1
    reservable true
    inauguration_date (Date.today + 45)
    name_definition 1
  end

  factory :camping_site do
    location_code 'B15'
    camping_type 'C'
    powered true
    reservable true
  end

  factory :reservation do
    start_date (Date.today + 30)
    end_date (Date.today + 34)
    reserved_for_name 'Alistair Alkmaar'
    telephone '123456789'
    mobile '123456789'
    email 'alistair.alkmaar@westgate.com.za'
    town 'Kimberley'
    meals_required true
    invoiced_amount 24555
    key_deposit_received true
    vehicle_registration_numbers 'JHB223388' 
    comments 'prefer to be far from bathrooms'
  end

  factory :rented_facility do
    rentable :camping_site
    reservation :reservation 
    start_date (Date.today + 30)
    end_date (Date.today + 34)
    adult_count 3
    child_6_12_count 2
    child_0_5_count 1
  end
end


