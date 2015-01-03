require 'spec_helper'

describe CampingSite do

  include FactoryGirl::Syntax::Methods
  
  before do
    @caravan = Caravan.new(location_code: 'C5')
  end

  subject { @caravan }

  it { should respond_to(:location_code) }
  it { should respond_to(:type) }
  it { should respond_to(:reservable) }
  it { should respond_to(:powered) }

  it "must be a valid object" do
    expect(@caravan).to be_valid
  end

  it "must have a valid factory" do
    caravan_factory = build(:caravan)
    expect(caravan_factory).to be_valid
    expect(caravan_factory.location_code).to eq('B15')
    expect(caravan_factory.type).to eq('Caravan')
    expect(caravan_factory.powered).to eq(true)
    expect(caravan_factory.reservable).to eq(true)
  end

  it "must ensure the location_code is valid" do
    @caravan.location_code = 'A'
    expect(@caravan).not_to be_valid
    @caravan.location_code = 'A' * 6
    expect(@caravan).not_to be_valid
    @caravan.location_code = ''
    expect(@caravan).not_to be_valid
  end

  it "must tell if a caravan is available between two dates" do
    date_1 = Date.new(2015,06,29)
    date_2 = Date.new(2015,07,01)
    site = create(:caravan)
    reservation = create(:reservation, start_date: date_1, end_date: date_2)
    rented_facility = create(:rented_facility, 
                              rentable: site, 
                              reservation: reservation,
                              start_date: date_1,
                              end_date: date_2)

    # Enquire availability for later period
    request_from = Date.new(2015,07,02)
    request_until = Date.new(2015,07,03)
    expect(site.available_between?(request_from, request_until)).to be(true)

    # Enquire availability for adjacent later period
    request_from = Date.new(2015,07,01)
    request_until = Date.new(2015,07,03)
    expect(site.available_between?(request_from, request_until)).to be(true)

    # Enquire availability for earlier period
    request_from = Date.new(2015,06,20)
    request_until = Date.new(2015,06,28)
    expect(site.available_between?(request_from, request_until)).to be(true)

    # Enquire availability for adjacent earlier period
    request_from = Date.new(2015,06,25)
    request_until = Date.new(2015,06,29)
    expect(site.available_between?(request_from, request_until)).to be(true)

    # Enquire availability for overlapping period - scenario 1
    request_from = Date.new(2015,06,25)
    request_until = Date.new(2015,06,30)
    expect(site.available_between?(request_from, request_until)).to be(false)

    # Enquire availability for overlapping period - scenario 2
    request_from = Date.new(2015,06,30)
    request_until = Date.new(2015,07,01)
    expect(site.available_between?(request_from, request_until)).to be(false)
  end
end