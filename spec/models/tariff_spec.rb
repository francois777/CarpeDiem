require 'spec_helper'

describe Tariff do

  include FactoryGirl::Syntax::Methods
  
  before do
    @tent_sites = create(:accommodation_type)
    @tariff = Tariff.new(
        tariff_category: 'C3',
        tariff: 8000,
        effective_date: Date.new(2010, 11, 30),
        accommodation_type_id: @tent_sites.id
      )
  end

  subject { @tariff }

  it { should respond_to(:tariff_category) }
  it { should respond_to(:tariff) }
  it { should respond_to(:effective_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:accommodation_type_id) }
  it { should respond_to(:accommodation_type) }

  it "must be valid" do
    expect(@tariff).to be_valid
  end

  it "must have a valid factory" do
    tariff_factory = build(:tariff, accommodation_type: @tent_sites)
    expect(tariff_factory).to be_valid
    expect(tariff_factory.accommodation_type).to eq(@tent_sites)
  end

  it "must ensure the tariff_category have a valid format" do
    @tariff.tariff_category = 'Z1'
    expect(@tariff).not_to be_valid
    @tariff.tariff_category = 'A 2'
    expect(@tariff).not_to be_valid
    @tariff.tariff_category = 'F9'
    expect(@tariff).not_to be_valid
  end

  it "must ensure the end_date cannot precede the effective_date" do
    @tariff.end_date = @tariff.effective_date - 1
    expect(@tariff).not_to be_valid
  end

  it "must accept a valid effective_date and end_date" do
    @tariff.end_date = @tariff.effective_date + 1
    expect(@tariff).to be_valid
  end

  it "must ensure the tariff is present" do
    @tariff.tariff = 0
    expect(@tariff).not_to be_valid
  end
end