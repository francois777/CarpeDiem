require 'spec_helper'

describe ReservationRequest do

  include FactoryGirl::Syntax::Methods
  
  before do
    @reservation_request = ReservationRequest.new(
      applicant_name: 'Willie Wolvaart',
      applicant_telephone: '123456789',
      applicant_mobile: '987654321',
      applicant_email: 'williewolvaart@myhome.co.za',
      applicant_town: 'Wolmaransstad',
      facility_type_1: 3,
      start_date_1: Date.new(2015, 7, 25),
      end_date_1: Date.new(2015, 8, 2),
      adults_18_plus_count_1: 2,
      teenagers_count_1: 2,
      children_6_12_count_1: 1,
      infants_count_1: 3,
      vehicle_registration_numbers: 'DC 12 TM GP',
      special_requests: 'We want heaters and a TV in our chalet'
      )
    @reservation_request2 = ReservationRequest.new(
      applicant_name: 'Willie Wolvaart',
      applicant_telephone: '123456789',
      applicant_mobile: '987654321',
      applicant_email: 'williewolvaart@myhome.co.za',
      applicant_town: 'Wolmaransstad',
      facility_type_1: 3,
      start_date_1: Date.new(2015, 7, 25),
      end_date_1: Date.new(2015, 8, 2),
      adults_18_plus_count_1: 2,
      teenagers_count_1: 2,
      children_6_12_count_1: 1,
      infants_count_1: 3,
      facility_type_2: 3,
      start_date_2: Date.new(2015, 7, 25),
      end_date_2: Date.new(2015, 8, 2),
      adults_18_plus_count_2: 2,
      teenagers_count_2: 2,
      children_6_12_count_2: 1,
      infants_count_2: 3,
      facility_type_3: 3,
      start_date_3: Date.new(2015, 7, 25),
      end_date_3: Date.new(2015, 8, 2),
      adults_18_plus_count_3: 2,
      teenagers_count_3: 2,
      children_6_12_count_3: 1,
      infants_count_3: 3,
      vehicle_registration_numbers: 'DC 12 TM GY',
      special_requests: 'We want heaters and a TV in our chalet',

      )
  end

  subject { @reservation_request }

  it { should respond_to(:applicant_name) }
  it { should respond_to(:applicant_telephone) }
  it { should respond_to(:applicant_mobile) }
  it { should respond_to(:applicant_email) }
  it { should respond_to(:facility_type_1) }
  it { should respond_to(:start_date_1) }
  it { should respond_to(:end_date_1) }
  it { should respond_to(:adults_18_plus_count_1) }
  it { should respond_to(:children_6_12_count_1) }
  it { should respond_to(:infants_count_1) }
  it { should respond_to(:facility_type_2) }
  it { should respond_to(:start_date_2) }
  it { should respond_to(:end_date_2) }
  it { should respond_to(:adults_18_plus_count_2) }
  it { should respond_to(:children_6_12_count_2) }
  it { should respond_to(:infants_count_2) }
  it { should respond_to(:facility_type_3) }
  it { should respond_to(:start_date_3) }
  it { should respond_to(:end_date_3) }
  it { should respond_to(:adults_18_plus_count_3) }
  it { should respond_to(:children_6_12_count_3) }
  it { should respond_to(:infants_count_3) }
  it { should respond_to(:meals_required_count) }
  it { should respond_to(:vehicle_registration_numbers) }
  it { should respond_to(:payable_amount) }
  it { should respond_to(:key_deposit_amount) }
  it { should respond_to(:estimated_arrival_time) }
  it { should respond_to(:reservation_reference_id) }
  it { should respond_to(:special_requests) }

  it "must be a valid object is one facility is being booked" do
    unless @reservation_request.valid?
      puts @reservation_request.errors.inspect
    end
    expect(@reservation_request).to be_valid
  end

  it "must be a valid object is three facilities are being booked" do
    unless @reservation_request2.valid?
      puts @reservation_request2.errors.inspect
    end
    expect(@reservation_request2).to be_valid
  end

  it "must ensure the applicant name has a valid format" do
    names = ["", "A234", 'N' * 41]
    names.each do |name|
      @reservation_request.applicant_name = name
      expect(@reservation_request).not_to be_valid
    end  
  end

  it "must ensure the applicant telephone has a valid format" do
    telnrs = ['9' * 8, '9' * 21]
    telnrs.each do |tel|
      @reservation_request.applicant_telephone = tel
      expect(@reservation_request).not_to be_valid
    end
  end

  it "must ensure the applicant mobile has a valid format" do
    telnrs = ['9' * 8, '9' * 21]
    telnrs.each do |tel|
      @reservation_request.applicant_mobile = tel
      expect(@reservation_request).not_to be_valid
    end
  end

  it "must ensure at least one contact number is required" do
    @reservation_request.applicant_telephone = ""
    @reservation_request.applicant_mobile = ""
    expect(@reservation_request).not_to be_valid
    @reservation_request.applicant_mobile = "555333444"  
    expect(@reservation_request).to be_valid
    @reservation_request.applicant_mobile = ""
    @reservation_request.applicant_telephone = "555333444"
    expect(@reservation_request).to be_valid
  end

  it "must ensure the email address has a valid format" do
    @reservation_request.applicant_email = 'sue.com.au'
    expect(@reservation_request).not_to be_valid
    @reservation_request.applicant_email = 'sue.scott@new.123'    
    expect(@reservation_request).not_to be_valid
    @reservation_request.applicant_email = 'jacktheripperswife@thebigbrownfox.thefoxcompany.com'
    expect(@reservation_request).not_to be_valid
  end

  it "must ensure the applicant town has a valid format" do
    @reservation_request.applicant_town = ""
    expect(@reservation_request).to be_valid
    towns = ['T', 'T' * 41]
    towns.each do |town|
      @reservation_request.applicant_town = town
      expect(@reservation_request).not_to be_valid
    end
  end

  it "must ensure start date (1) is valid" do
    @reservation_request.start_date_1 = nil
    expect(@reservation_request).not_to be_valid
    @reservation_request.start_date_1 = Date.today - 1
    expect(@reservation_request).not_to be_valid
  end

  it "must ensure end date (1) is valid" do
    @reservation_request.end_date_1 = nil
    expect(@reservation_request).not_to be_valid
    @reservation_request.end_date_1 = @reservation_request.start_date_1
    expect(@reservation_request).not_to be_valid
    @reservation_request.end_date_1 = @reservation_request.start_date_1.to_datetime - 1
    expect(@reservation_request).not_to be_valid
  end

  it "must ensure that facility 1 has at least one person is specified" do
    @reservation_request.adults_18_plus_count_1 = 0
    @reservation_request.teenagers_count_1 = 0
    @reservation_request.children_6_12_count_1 = 0
    @reservation_request.infants_count_1 = 0
    expect(@reservation_request).not_to be_valid
  end

  it "must ensure that caravan facility (1) has an adult when there are infants" do
    @reservation_request.facility_type_1 = 1
    @reservation_request.adults_18_plus_count_1 = 0
    @reservation_request.infants_count_1 = 1    
    expect(@reservation_request).not_to be_valid
  end

  it "must allow a caravan facility (1) to have no adults when no infants are present" do
    @reservation_request.facility_type_1 = 1
    @reservation_request.adults_18_plus_count_1 = 0
    @reservation_request.infants_count_1 = 0 
    expect(@reservation_request).to be_valid
  end

  it "must ensure start date (2) requires an end date" do
    @reservation_request2.start_date_2 = Date.today
    @reservation_request2.end_date_2 = Date.today
    expect(@reservation_request2).not_to be_valid
    @reservation_request2.end_date_2 = Date.today + 1
    expect(@reservation_request2).to be_valid
  end

  it "must ensure end date (2) is valid" do
    @reservation_request2.end_date_2 = @reservation_request2.start_date_2
    expect(@reservation_request2).not_to be_valid
    @reservation_request2.end_date_2 = @reservation_request2.start_date_2.to_datetime - 1
    expect(@reservation_request2).not_to be_valid
  end

  it "must ensure that facility (2) has at least one person is specified" do
    @reservation_request2.adults_18_plus_count_2 = 0
    @reservation_request2.teenagers_count_2 = 0
    @reservation_request2.children_6_12_count_2 = 0
    @reservation_request2.infants_count_2 = 0
    expect(@reservation_request2).not_to be_valid
  end

  it "must ensure that caravan facility (2) has an adult when there are infants" do
    @reservation_request2.facility_type_2 = 1
    @reservation_request2.adults_18_plus_count_2 = 0
    @reservation_request2.infants_count_2 = 1    
    expect(@reservation_request2).not_to be_valid
  end

  it "must allow a caravan facility (2) to have no adults when no infants are present" do
    @reservation_request2.facility_type_2 = 1
    @reservation_request2.adults_18_plus_count_2 = 0
    @reservation_request2.infants_count_2 = 0 
    expect(@reservation_request2).to be_valid
  end

  it "must ensure start date (3) requires an end date" do
    @reservation_request2.start_date_3 = Date.today
    @reservation_request2.end_date_3 = Date.today
    expect(@reservation_request2).not_to be_valid
    @reservation_request2.end_date_3 = Date.today + 1
    expect(@reservation_request2).to be_valid
  end

  it "must ensure end date (3) is valid" do
    @reservation_request2.end_date_3 = @reservation_request2.start_date_3
    expect(@reservation_request2).not_to be_valid
    @reservation_request2.end_date_3 = @reservation_request2.start_date_3.to_datetime - 1
    expect(@reservation_request2).not_to be_valid
  end

  it "must ensure that facility (3) has at least one person is specified" do
    @reservation_request2.adults_18_plus_count_3 = 0
    @reservation_request2.teenagers_count_3 = 0
    @reservation_request2.children_6_12_count_3 = 0
    @reservation_request2.infants_count_3 = 0
    expect(@reservation_request2).not_to be_valid
  end

  it "must ensure that caravan facility (3) has an adult when there are infants" do
    @reservation_request2.facility_type_3 = 1
    @reservation_request2.adults_18_plus_count_3 = 0
    @reservation_request2.infants_count_3 = 1    
    expect(@reservation_request2).not_to be_valid
  end

  it "must allow a caravan facility (3) to have no adults when no infants are present" do
    @reservation_request2.facility_type_3 = 1
    @reservation_request2.adults_18_plus_count_3 = 0
    @reservation_request2.infants_count_3 = 0 
    expect(@reservation_request2).to be_valid
  end

end