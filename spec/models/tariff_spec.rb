require 'spec_helper'

describe Tariff do

  include FactoryGirl::Syntax::Methods
  
  before do
    @tariff = Tariff.new(
        tariff_category: 'C3',
        tariff: 8000,
        effective_date: Date.new(2010, 11, 30)
      )
  end

  subject { @tariff }

  it { should respond_to(:tariff_category) }
  it { should respond_to(:tariff) }
  it { should respond_to(:effective_date) }
  it { should respond_to(:end_date) }

  it "must be valid" do
    expect(@tariff).to be_valid
  end

  it "must have a valid factory" do
    tariff_factory = build(:tariff)
    expect(tariff_factory).to be_valid
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