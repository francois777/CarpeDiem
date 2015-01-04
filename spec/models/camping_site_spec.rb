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

  describe "When no caravans have been booked" do

    before do
      @caravan1 = create(:caravan, location_code: 'C101')
      @caravan2 = create(:caravan, location_code: 'C102')
      @date_1 = Date.new(2015,06,29)
      @date_2 = Date.new(2015,07,01)
    end

    it "must tell that all caravans are available between a specified period" do
      count = Caravan.available_count_between(@date_1, @date_2)
      expect(count).to eq(Caravan.all.count)
    end

    it "must only count caravans that are reservable" do
      @caravan1.reservable = false
      @caravan1.save
      count = Caravan.available_count_between(@date_1, @date_2)
      expect(count).to eq(Caravan.all.count - 1)
    end
  end

  describe "When there are some reservations" do
    before do
      @caravan1 = create(:caravan, location_code: 'C101')
      @caravan2 = create(:caravan, location_code: 'C102')
      @caravan3 = create(:caravan, location_code: 'C103')
      @date_1 = Date.new(2015,06,29)
      @date_2 = Date.new(2015,07,03)
      @reservation1 = create(:reservation, start_date: @date_1, end_date: @date_2)
      @rented_facility1 = create(:rented_facility, rentable: @caravan1, reservation: @reservation1, start_date: @date_1, end_date: @date_2)
    end

    it "must not count a caravan while it is reserved" do
      count = Caravan.available_count_between(@date_1 + 1, @date_2 - 1)
      expect(count).to eq(Caravan.all.count - 1)
    end

    it "must not count a second caravan that is also reserved" do
      rented_facility2 = create(:rented_facility, rentable: @caravan2, reservation: @reservation1, start_date: @date_1, end_date: @date_2)
      count = Caravan.available_count_between(@date_1 - 1, @date_2 + 1)
      expect(count).to eq(Caravan.all.count - 2)
    end

    it "must not count any caravans that are reserved or not reservable" do
      rented_facility2 = create(:rented_facility, rentable: @caravan2, reservation: @reservation1, start_date: @date_1, end_date: @date_2)
      @caravan3.reservable = false
      @caravan3.save
      count = Caravan.available_count_between(@date_1, @date_2 - 2)
      expect(count).to eq(Caravan.all.count - 3)
    end
  end
end