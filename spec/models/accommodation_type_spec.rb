require 'spec_helper'

describe AccommodationType do

  include FactoryGirl::Syntax::Methods
  
  before do
    @accommodation_type = AccommodationType.new(
      accom_type: 'B',
      description: 'Tent Site With Power',
      show: true,
      show_normal_price: true,
      show_in_season_price: true,
      show_promotion: true
    )
  end

  subject { @accommodation_type }

  it { should respond_to(:accom_type) }
  it { should respond_to(:description) }
  it { should respond_to(:show) }
  it { should respond_to(:show_normal_price) }
  it { should respond_to(:show_in_season_price) }
  it { should respond_to(:show_promotion) }

  it "must be valid" do
    expect(@accommodation_type).to be_valid
  end

  it "must have a valid factory" do
    accommodation_type_factory = build(:accommodation_type)
    expect(accommodation_type_factory).to be_valid
  end

  it "must ensure the accom_type have a valid format" do
    @accommodation_type.accom_type = 'CC'
    expect(@accommodation_type).not_to be_valid
  end
  
  it 'must ensure that duplicates are not allowed' do
    @accommodation_type.save
    other_accommodation_type = @accommodation_type.dup
    expect(other_accommodation_type).not_to be_valid
  end  

  it 'must know about its child tariffs' do
    t1 = create(:tariff, tariff_category: 'B1', accommodation_type: @accommodation_type)
    t2 = create(:tariff, tariff_category: 'B2', accommodation_type: @accommodation_type)
    expect(@accommodation_type.tariffs.count).to eq(2)
    expect(@accommodation_type.tariffs).to eq [t1, t2]
  end

end  