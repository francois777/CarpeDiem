require 'spec_helper'

feature "Event pages" do

  include FactoryGirl::Syntax::Methods
  # include ApplicationHelper
  include SessionsHelper

  context "Admin user create new event" do

    before do
      admin = create(:admin)
      @event = create(:event)
      login(admin)
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
      fill_in "Number of guests", with: '16'
      fill_in "Number of chalets required", with: '3'
      find(:css, "#event_power_required").set(true)
      find(:css, "#event_meals_required").set(true)
      fill_in "Estimated cost quoted", with: '123.45'

      # click_button "Create Event" 

      # expect(page).to have_text('Event created successfully')
      # expect(page).to have_title('Event Details')
      # expect(page).to have_selector('h1', text: "Event Details")
      # expect( find(:css, "input#event_title").value ).to eq('Chalet Luxury, Promotion')
      # expect( find(:css, "input#tariff_tariff").value ).to eq('R 55.90')
    end

  end

  def login(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

end

