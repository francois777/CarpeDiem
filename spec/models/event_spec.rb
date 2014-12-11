require 'spec_helper'

describe Event do

  include FactoryGirl::Syntax::Methods
  
  before do
    @event = Event.new(
        title: 'Our Planning Event',
        organiser_name: 'Dr Louis Livingston',
        organiser_telephone: '03 1342 6433',
        start_date: Date.new(2015, 05, 20),
        end_date: Date.new(2015, 05, 20)
      )
  end

  subject { @event }

  it { should respond_to(:title) }
  it { should respond_to(:organiser_name) }
  it { should respond_to(:organiser_telephone) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:confirmed) }
  it { should respond_to(:estimated_guests_count) }
  it { should respond_to(:estimated_chalets_required) }
  it { should respond_to(:estimated_sites_required) }
  it { should respond_to(:power_required) }
  it { should respond_to(:meals_required) }
  it { should respond_to(:quoted_cost) }
  it { should respond_to(:comments) }

  it "must be valid" do
    expect(@event).to be_valid
  end

  it "must have a valid factory" do
    event_factory = build(:event)
    expect(event_factory).to be_valid
    expect(event_factory.title).to eq('Annual Staff Reunion')
    expect(event_factory.organiser_name).to eq('Victor Korestensky')
    expect(event_factory.start_date).to eq(Date.today + 30)
    expect(event_factory.end_date).to eq(Date.today + 34)
    expect(event_factory.confirmed).to eq(true)
    expect(event_factory.estimated_guests_count).to eq(20)
    expect(event_factory.estimated_sites_required).to eq(3)
    expect(event_factory.power_required).to eq(true)
    expect(event_factory.meals_required).to eq(true)
    expect(event_factory.quoted_cost).to eq(35000)
    expect(event_factory.comments).to eq('Will confirm in two weeks')
  end

  it "must ensure the event title has a valid format" do
    titles = ["", "9 letters", 'E' * 51]
    titles.each do |title|
      @event.title = title
      expect(@event).not_to be_valid
    end  
  end

  it "must ensure the organiser name has a valid format" do
    names = ["", "abcd", "O" * 41]
    names.each do |name|
      @event.organiser_name = name
      expect(@event).not_to be_valid
    end
  end

  it "must ensure the organiser telephone has a valid format" do
    tels = ["", "8 lettrs", "T" * 21]
    tels.each do |tel|
      @event.organiser_telephone = tel
      expect(@event).not_to be_valid
    end
  end

  it "must ensure the start date is valid" do
    @event.start_date = nil
    expect(@event).not_to be_valid
  end

  it "must ensure the end date is valid" do
    @event.end_date = @event.start_date - 1
    expect(@event).not_to be_valid
  end

  it "must know about its diarisable children" do
    @event.save
    expect(@event.diary_days.count).to eq(1)
  end

  it "must not exceed the maximum duration" do
    @event.end_date = @event.start_date.to_datetime + 14
    expect(@event).not_to be_valid
  end

end