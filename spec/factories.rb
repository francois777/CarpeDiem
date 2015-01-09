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
    end_date nil
    price_class 0
    facility_category 0
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

  factory :caravan do
    location_code 'B15'
    powered true
    reservable true
  end

  factory :tent do
    location_code 'T09'
    powered true
    reservable true
  end

  factory :reservation_request do
    applicant_name 'Daphne Norman' 
    applicant_telephone '223344889'
    applicant_mobile '343434349'
    applicant_email 'daphne.norman@gmail.com'
    applicant_town 'Harrismith'
    facility_type_1        3
    start_date_1 (Date.today + 10)
    end_date_1   (Date.today + 12)
    adults_18_plus_count_1 3
    teenagers_count_1      1
    children_6_12_count_1  2
    infants_count_1        2
    power_point_required_1 false
    facility_type_2        1
    start_date_2 (Date.today + 10)
    end_date_2   (Date.today + 12)
    adults_18_plus_count_2 1
    teenagers_count_2      2
    children_6_12_count_2  3
    infants_count_2        0
    power_point_required_2 true
    facility_type_3        0
    start_date_3 (Date.today + 10)
    end_date_3   (Date.today + 12)
    adults_18_plus_count_3 0
    teenagers_count_3      4
    children_6_12_count_3  2
    infants_count_3        0
    power_point_required_3 false
    meals_required_count   0
    vehicle_registration_numbers 'RHC 12 12 10, UX 15 38 48'
    payable_amount 0
    key_deposit_amount 0 
    estimated_arrival_time nil
    special_requests  'Please puts us all close to each other'
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


