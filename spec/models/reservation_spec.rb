require 'spec_helper'

describe Reservation do

  include FactoryGirl::Syntax::Methods
  
  before do
    @reservation = Reservation.new(
        start_date: Date.new(2015, 05, 20),
        end_date: Date.new(2015, 05, 22),
        reserved_for_name: 'Hans Grobler',
        reserved_datetime: Time.now,
        telephone: 333666999,
        mobile: 224466889,
        email: 'hansgrobler123@hotmail.com',
        town: 'Matjiesfontein',
        meals_required: false,
        invoiced_amount: 34099,
        key_deposit_received: false,
        vehicle_registration_numbers: 'KLS200300, PAR333888',
        comments: 'We need a baby cot'
      )
  end

  subject { @reservation }

  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:reserved_for_name) }
  it { should respond_to(:reserved_datetime) }
  it { should respond_to(:telephone) }
  it { should respond_to(:town) }
  it { should respond_to(:meals_required) }
  it { should respond_to(:invoiced_amount) }
  it { should respond_to(:key_deposit_received) }
  it { should respond_to(:vehicle_registration_numbers) }
  it { should respond_to(:comments) }

  it "must be a valid object" do
    expect(@reservation).to be_valid
    @reservation.save!
    expect(@reservation.reservation_reference).not_to be_nil
  end

  it "must have a valid factory" do
    reservation_factory = build(:reservation)
    expect(reservation_factory).to be_valid
    expect(reservation_factory.start_date).to eq(Date.today + 30)
    expect(reservation_factory.end_date).to eq(Date.today + 34)
    expect(reservation_factory.reserved_for_name).to eq('Alistair Alkmaar')
    expect(reservation_factory.telephone).to eq('123456789')
    expect(reservation_factory.mobile).to eq('123456789')
    expect(reservation_factory.email).to eq('alistair.alkmaar@westgate.com.za')
    expect(reservation_factory.town).to eq('Kimberley')
    expect(reservation_factory.meals_required).to eq(true)
    expect(reservation_factory.invoiced_amount).to eq(24555)
    expect(reservation_factory.key_deposit_received).to eq(true)
    expect(reservation_factory.vehicle_registration_numbers).to eq('JHB223388')
    expect(reservation_factory.comments).to eq('prefer to be far from bathrooms')
    reservation_factory.save!
    reservation_factory.reload.reserved_datetime
    # expect(reservation_factory.reserved_datetime).to be_within(100).of(Time.now)
  end

  it "must ensure the start date is valid" do
    @reservation.start_date = nil
    expect(@reservation).not_to be_valid
  end

  it "must ensure the end date is valid" do
    @reservation.end_date = @reservation.start_date - 1
    expect(@reservation).not_to be_valid
  end

  it "must ensure the reserved_for_name has a valid format" do
    names = ["", "4 le", 'N' * 41]
    names.each do |name|
      @reservation.reserved_for_name = name
      expect(@reservation).not_to be_valid
    end  
  end

  it "must ensure the telephone has a valid format" do
    tels = ["8 lettrs", "T" * 21]
    tels.each do |tel|
      @reservation.telephone = tel
      expect(@reservation).not_to be_valid
    end
  end

  it "must ensure the mobile has a valid format" do
    tels = ["8 lettrs", "T" * 21]
    tels.each do |tel|
      @reservation.mobile = tel
      expect(@reservation).not_to be_valid
    end
  end

  it "must ensure the email address has a valid format" do
    @reservation.email = 'sue.com.au'
    expect(@reservation).not_to be_valid
    @reservation.email = 'sue.scott@new.123'    
    expect(@reservation).not_to be_valid
    @reservation.email = 'jacktheripperswife@thebigbrownfox.thefoxcompany.com'
    expect(@reservation).not_to be_valid
  end

  it "must ensure the town has a valid format" do
    towns = ["A", "T" * 41]
    towns.each do |town|
      @reservation.town = town
      expect(@reservation).not_to be_valid
    end
  end

end  
