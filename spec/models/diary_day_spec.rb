require 'spec_helper'

describe DiaryDay do

  include FactoryGirl::Syntax::Methods
  
  before do
    @event = create(:event)
    test_date = Date.new
    @diaryday = DiaryDay.new(
        day: test_date,
        diarisable: @event
      )
  end

  subject { @diaryday }

  it { should respond_to(:day) }
  it { should respond_to(:diarisable) }

  it "must be valid" do
    expect(@diaryday).to be_valid
  end

  it "must have a valid factory" do
    diary_factory_1 = build(:diary_day)
    diary_factory_2 = build(:diary_day)
    expect(diary_factory_1).to be_valid
    expect(diary_factory_2).to be_valid
  end

  it "must ensure that a new DiaryDay includes a date" do
    @diaryday.day = nil
    expect(@diaryday).not_to be_valid
  end

  it "must know its diarisable parent" do
    expect(@diaryday.diarisable).to eq(@event)
  end
end