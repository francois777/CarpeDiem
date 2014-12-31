require 'spec_helper'

describe Chalet do

  include FactoryGirl::Syntax::Methods
  
  before do
    @chalet = Chalet.new(
        name: 'Jacob',
        location_code: 'B8',
        style_class: 2,
        reservable: true,
        inauguration_date: Date.today + 55,
        name_definition: 5
      )
  end

  subject { @chalet }

  it { should respond_to(:name) }
  it { should respond_to(:location_code) }
  it { should respond_to(:style_class) }
  it { should respond_to(:reservable) }
  it { should respond_to(:inauguration_date) }
  it { should respond_to(:name_definition) }

  it "must have a valid factory" do
    chalet_factory = build(:chalet)
    expect(chalet_factory).to be_valid
    expect(chalet_factory.name).to eq('Simeon')
    expect(chalet_factory.location_code).to eq('A12')
    expect(chalet_factory.style_class).to eq('medium')
    expect(chalet_factory.reservable).to eq(true)
    expect(chalet_factory.inauguration_date).to eq(Date.today + 45)
    expect(chalet_factory.name_definition).to eq(1)
  end

  it "must ensure the name is valid" do
    @chalet.name = 'AA'
    expect(@chalet).not_to be_valid
    @chalet.name = 'A' * 21
    expect(@chalet).not_to be_valid
    @chalet.name = ''
    expect(@chalet).not_to be_valid
  end

  it "must ensure the name is unique" do
    @chalet.save
    chalet2 = @chalet.dup
    expect(chalet2).not_to be_valid    
  end

  it "must ensure the location_code is valid" do
    @chalet.location_code = 'A'
    expect(@chalet).not_to be_valid
    @chalet.location_code = 'A' * 6
    expect(@chalet).not_to be_valid
    @chalet.location_code = ''
    expect(@chalet).not_to be_valid
  end

  it "must allow valid chalet style_classes" do
    Chalet::STYLE_CLASSES.each do |sc|
      @chalet.style_class = sc.to_sym;
      expect(@chalet).to be_valid
    end
  end

  it "must reject invalid style_classes" do
    expect {@chalet.style_class = :invalid }.to raise_error
  end

  it "must tell if a chalet is available between two dates" do
    date_1 = Date.new(2015,06,29)
    date_2 = Date.new(2015,07,01)
    site = create(:chalet)
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