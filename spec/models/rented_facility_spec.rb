require 'spec_helper'

describe RentedFacility do

  include FactoryGirl::Syntax::Methods
  
  before do
    @reservation_start = Date.today + 14
    @reservation_end = Date.today + 17
    @caravan = create(:caravan)
    @chalet = create(:chalet)
    @reservation = create(:reservation, 
      start_date: @reservation_start, 
      end_date: @reservation_end,
      email: 'john.knox@msn.com')
    @rented_facility = RentedFacility.new(
      start_date: @reservation_start,
      end_date: @reservation_end,
      rentable: @caravan,
      reservation: @reservation,
      adult_count: 3,
      child_6_12_count: 2,
      child_0_5_count: 1
      )
  end

  subject { @rented_facility }

  it { should respond_to(:reservation) }
  it { should respond_to(:rentable) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:reservation) }
  it { should respond_to(:adult_count) }
  it { should respond_to(:child_6_12_count) }
  it { should respond_to(:child_0_5_count) }

  it "must be valid" do
    expect(@rented_facility).to be_valid
  end

  it "must have a valid factory" do
    site = create(:caravan, location_code: 'C12')
    reservation = create(:reservation)
    rented_facility_factory = create(:rented_facility, rentable: site, reservation: reservation)
    expect(rented_facility_factory).to be_valid
    expect(rented_facility_factory.reservation).to be_valid
    expect(rented_facility_factory.start_date).to eq(Date.today + 30)
    expect(rented_facility_factory.end_date).to eq(Date.today + 34)
    expect(rented_facility_factory.adult_count).to eq(3)
    expect(rented_facility_factory.child_6_12_count).to eq(2)
    expect(rented_facility_factory.child_0_5_count).to eq(1)
  end

  it "must have a diary day for each day of reservation" do
    @rented_facility.save!
    day_first = @reservation_start.to_datetime
    day_last = @reservation_end.to_datetime
    expect(@rented_facility.diary_days.count).to eq(day_last - day_first + 1)
    while day_first <= day_last do
      expect(DiaryDay.find_by_day(day_first)).to be_valid
      day_first += 1
    end
  end

  it "must ensure the start date is valid" do
    @rented_facility.start_date = nil
    expect(@rented_facility).not_to be_valid
  end

  it "must ensure the end date is valid" do
    @rented_facility.end_date = @rented_facility.start_date - 1
    expect(@rented_facility).not_to be_valid
  end

  it "must be able to reference the associated camping_site" do
    expect(@rented_facility.rentable).to eq(@caravan)
  end

  it "must be able to reference the associated chalet" do
    @rented_facility.rentable = @chalet
    expect(@rented_facility.rentable).to eq(@chalet)
  end

  it "must ensure that at least one occupant is specified" do
    @rented_facility.adult_count = 0
    @rented_facility.child_6_12_count = 0
    @rented_facility.child_0_5_count = 0
    expect(@rented_facility).not_to be_valid
  end

  it "must ensure that an adult is required if infants are present" do
    @rented_facility.adult_count = 0
    @rented_facility.child_6_12_count = 3
    @rented_facility.child_0_5_count = 2
    expect(@rented_facility).not_to be_valid
  end

end

