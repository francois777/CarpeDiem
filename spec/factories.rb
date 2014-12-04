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

  factory :season_detail_line do
    add_attribute :sequence, 1
    season_group_type 0
    line_col_1 'TENT SITES'
    line_col_2 'R110'
    line_col_3 'R70 (children 6-12yr=R40)'
    line_col_4 'Maximum 6 persons per site'
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
    effective_date Date.today - 300
    end_date Date.today + 300
  end

end


