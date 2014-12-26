require 'spec_helper'

describe CampingSite do

  include FactoryGirl::Syntax::Methods
  
  before do
    @camping_site = CampingSite.new(location_code: 'C5')
  end

  subject { @camping_site }

  it { should respond_to(:location_code) }
  it { should respond_to(:camping_type) }
  it { should respond_to(:reservable) }
  it { should respond_to(:powered) }

  it "must be a valid object" do
    expect(@camping_site).to be_valid
  end

  it "must have a valid factory" do
    camping_site_factory = build(:camping_site)
    expect(camping_site_factory).to be_valid
    expect(camping_site_factory.location_code).to eq('B15')
    expect(camping_site_factory.camping_type).to eq('C')
    expect(camping_site_factory.powered).to eq(true)
    expect(camping_site_factory.reservable).to eq(true)
  end

  it "must ensure the location_code is valid" do
    @camping_site.location_code = 'A'
    expect(@camping_site).not_to be_valid
    @camping_site.location_code = 'A' * 6
    expect(@camping_site).not_to be_valid
    @camping_site.location_code = ''
    expect(@camping_site).not_to be_valid
  end

  it "must ensure the camping_type is valid" do
    @camping_site.camping_type = 'C'
    expect(@camping_site).to be_valid
    @camping_site.camping_type = 'X'
    expect(@camping_site).not_to be_valid
  end

  it "must tell if a camping_site is available between two dates" do
    date_1 = Date.new(2015,06,29)
    date_2 = Date.new(2015,07,01)
    site = create(:camping_site)
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