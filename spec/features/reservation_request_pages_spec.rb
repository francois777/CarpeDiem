require 'spec_helper'

feature "ReservationRequest pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper
  include SessionsHelper

  context "Website visitor create events" do

    before do
      @reservation_request = create(:reservation_request)
    end

    scenario "Visit new reservation request page" do
      visit new_reservation_request_path
      expect(page).to have_title('Reservation Request')
      expect(page).to have_selector('h1', text: "Reservation Request")
      expect(page).to have_text('First Reservation')
      expect(page).to have_text('Name and Surname')
      expect(page).to have_text('Telephone number')
      expect(page).to have_text('Mobile number')
      expect(page).to have_text('Email')
      expect(page).to have_text('Home town')
      expect(page).to have_text('First Reservation')
      expect(page).to have_text('Type of accommodation')
      expect(page).to have_text('Arrival date')
      expect(page).to have_text('Adults (18 years and older)')
      expect(page).to have_text('Children (13 to 17 years)')
      expect(page).to have_text('Children (6 to 12 years)')
      expect(page).to have_text('Todlers (0 to 5 years)')
      expect(page).to have_text('Power point required?')
      expect(page).to have_text('Second facility required?')
      expect(page).to have_text('Third facility required?')

      # Show the second facility
      find(:css, "#Second_facility_required_").set(true)
      expect(page).to have_text('Second Reservation')

      # Show the third facility
      find(:css, "#Third_facility_required_").set(true)
      expect(page).to have_text('Third Reservation')
    end
  end
end