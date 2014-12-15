require 'spec_helper'

feature "Event pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper
  include SessionsHelper

  context "Admin user create events" do

    before do
      @admin = create(:admin)
      @event = create(:event)
      login(@admin)
    end

    scenario "Visit new event page" do
      visit new_admin_event_path
      expect(page).to have_title('New Event')
      expect(page).to have_selector('h1', text: "New Event")
      expect(page).to have_text('Event Name')
      expect(page).to have_text('Start Date')
      expect(page).to have_text('End Date')
      expect(page).to have_text('Organiser Name')
      expect(page).to have_text('Organiser Telephone')
      expect(page).to have_text('Confirmed?')
      expect(page).to have_text('Number of guests')
      expect(page).to have_text('Number of chalets required')
      expect(page).to have_text('Power required?')
      expect(page).to have_text('Meals required?')
      expect(page).to have_text('Estimated cost quoted')
      expect(page).to have_selector(:button, 'Create Event')
    end

    scenario "Create new event" do
      visit new_admin_event_path
      fill_in "Event Name", with: "Parents Retriet"
      fill_in "Organiser Name", with: "Brenda Booysens"
      fill_in "Organiser Telephone", with: '7 2762 2625'
      fill_in "Start Date", with: "31/03/2015"
      fill_in "End Date", with: "01/04/2015"
      find(:css, "#event_confirmed").set(true)
      fill_in "Number of guests", with: 16
      fill_in "Number of chalets required", with: 3
      find(:css, "#event_power_required").set(true)
      find(:css, "#event_meals_required").set(true)
      fill_in "Estimated cost quoted", with: '123.45'
      click_button "Create Event" 

      expect(page).to have_text('Event created successfully')
      expect(page).to have_title('Event Details')
      expect(page).to have_selector('h1', text: "Event Details")
    end
  end

  context "Admin user views events" do

    before do
      @admin = create(:admin)
      @event = create(:event)
      login(@admin)
    end

    subject { page }

    scenario "Admin user view single event (as administrator)" do
      @event.start_date = Date.new(2015, 3, 31)
      @event.end_date = Date.new(2015, 4, 1)
      @event.save
      visit event_path(@event)
      expect(page).to have_title('Event Details')
      expect(page).to have_selector('h1', text: "Event Details")
      expect(page).to have_text('Organiser Name')
      expect(page).to have_text('Organiser Telephone')
      expect(page).to have_text('Start Date')
      expect(page).to have_text('End Date')
      expect(page).to have_text('Confirmed?')
      expect(page).to have_text('Number of guests')
      expect(page).to have_text('Number of chalets required')
      expect(page).to have_text('Power required?')
      expect(page).to have_text('Meals required?')
      expect(page).to have_text('Estimated cost quoted')
      expect(page).to have_selector(:button, 'Edit Event')

      expect( find(:css, "input#event_title").value).to eq('Annual Staff Reunion')
      expect( find(:css, "input#event_organiser_name").value).to eq('Victor Korestensky')
      expect( find(:css, "input#event_organiser_telephone").value).to eq('08 6511 1122')
      expect( find(:css, "input#event_start_date").value ).to eq('31 March 2015')
      expect( find(:css, "input#event_end_date").value ).to eq('01 April 2015')
      expect( find(:css, "input#event_confirmed").value).to eq "Yes"
      expect( find(:css, "input#event_estimated_guests_count").value ).to eq('20')
      expect( find(:css, "input#event_estimated_chalets_required").value ).to eq('2')
      expect( find(:css, "input#event_power_required").value).to eq "Yes"
      expect( find(:css, "input#event_meals_required").value).to eq "Yes"
      expect( find(:css, "input#event_quoted_cost").value).to eq "R 350.00"
      expect(page).to have_selector(:button, 'Return to calendar')
      expect(page).to have_selector(:button, 'Edit Event')
    end

    scenario "Admin user looks at month calender" do
      title = @event.title
      diary_day = @event.diary_days.first
      puts diary_day.inspect
      current_month = Date.today.strftime("%B")
      visit events_path
      expect(page).to have_title('Events')
      expect(page).to have_selector('h2', text: current_month)
      expect(page).to have_selector(:button, 'Add Event')
      #expect( find(:css, "a[data-event-id='#{@event.id.to_s}']").first.text ).to eq(title)

    end

  end

  context "Admin user updates an event" do

    before do
      @admin = create(:admin)
      @event = create(:event)
      login(@admin)
    end

    scenario "Update an event (as administrator)" do
      visit event_path(@event)
      expect(page).to have_selector(:button, 'Edit Event')
      visit edit_admin_event_path(@event)
      expect(page).to have_title('Update Event')
      expect(page).to have_selector('h1', text: "Update Event")
      expect(page).to have_text('Event Name')
      expect(page).to have_text('Start Date')
      expect(page).to have_text('End Date')
      expect(page).to have_text('Organiser Name')
      expect(page).to have_text('Organiser Telephone')
      expect(page).to have_text('Confirmed?')
      expect(page).to have_text('Number of guests')
      expect(page).to have_text('Number of chalets required')
      expect(page).to have_text('Power required?')
      expect(page).to have_text('Meals required?')
      expect(page).to have_text('Estimated cost quoted')
      expect(page).to have_selector(:button, 'Update Event')
    end
  end

  def login(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

end

