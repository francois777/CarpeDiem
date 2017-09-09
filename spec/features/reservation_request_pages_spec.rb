require 'spec_helper'

feature "ReservationRequest pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper
  include SessionsHelper

  context "Potential camper creates reservation request" do

    before do
      create(:caravan)
      accom_type = create(:accommodation_type, accom_type: 'A')
      accom_type = create(:accommodation_type, accom_type: 'C')
      tariff1 = create(:tariff,
          tariff_category: 'D3',
          tariff: 8000,
          effective_date: Date.new(2018, 2, 1),
          end_date: nil,
          accommodation_type: accom_type,
          with_power_points: true,
          facility_category: Tariff.facility_categories["caravan"],
          price_class: :normal_price)
      tariff2 = create(:tariff,
          tariff_category: 'E3',
          tariff: 6000,
          effective_date: Date.new(2018, 2, 1),
          end_date: nil,
          accommodation_type: accom_type,
          with_power_points: false,
          facility_category: Tariff.facility_categories["tent"],
          price_class: :normal_price)

      @reservation_request = create(:reservation_request, start_date_1: Date.new(2018, 8, 2), end_date_1: Date.new(2018, 8, 5))
    end

    scenario "New Accommodation Enquiry must display all necessary fields" do
      visit new_reservation_request_path
      expect(page).to have_title('Accommodation Enquiry')
      expect(page).to have_selector('h1', text: "Accommodation Enquiry")
      expect(page).to have_text('First Reservation')
      expect(page).to have_text('Name and Surname')
      expect(page).to have_text('Telephone number')
      expect(page).to have_text('Mobile number')
      expect(page).to have_text('Email')
      expect(page).to have_text('Home town')
      expect(page).to have_text('First Reservation')
      expect(page).to have_text('Facility')
      expect(page).to have_text('Arrival date')
      expect(page).to have_text('Adults (18+)')
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
      expect(page).to have_button('Save and Review')
    end

    scenario "After saving an enquiry, review the saved fields with amounts" do
      visit new_reservation_request_path

      fill_in_applicant_details
      within(:css, "#first-facility") do
        select  "Caravan", from: "Facility"
      end
      fill_in_facility_1

      click_button "Save and Review"
      expect(page).to have_title('Update Reservation')
      verify_applicant_details_are_correct
      verify_facility_1_details_are_correct
      expect(page).to have_text('160.00')
      expect(page).to have_text('56.00')
      expect(page).to have_text('R 376.00')

      expect(page).to have_text("Reservation Request Saved. Review and Submit.")
      expect(page).to have_button('Save and Review')
      expect(page).to have_button('Submit Request')

      click_button "Save and Review"
    end

    scenario "Provide details for two facilities and view the results" do
      create(:tent, location_code: 'B1')
      create(:caravan, location_code: 'C2')
      visit new_reservation_request_path
      fill_in_applicant_details
      within(:css, "#first-facility") do
        select  "Caravan", from: "Facility"
      end
      fill_in_facility_1

      find(:css, "#Second_facility_required_").set(true)
      within(:css, "#second-facility") do
        select  "Tent", from: "Facility"
      end
      fill_in_facility_2
      expect(page).to have_button('Save and Review')

      click_button 'Save and Review'
      expect(page).to have_title('Update Reservation')
      verify_applicant_details_are_correct
      verify_facility_1_details_are_correct
      expect(page).to have_text('160.00')
      expect(page).to have_text('56.00')
      expect(page).to have_text('R 376.00')

      verify_facility_2_details_are_correct
      expect(page).to have_text('120.00')
      expect(page).to have_text('180.00')
      expect(page).to have_text('42.00')
      expect(page).to have_text('R 342.00')

      expect(page).to have_button('Save and Review')
      expect(page).to have_button('Submit Request')
    end
  end

  context "Potential camper fill in enquiry form with errors" do

    before do
      create(:small_chalet)
    end

    scenario "Provide incorrect applicant details" do
      visit new_reservation_request_path
      fill_in "Name and Surname", with: "abcd"
      fill_in "Telephone", with: '112233445'
      fill_in "Mobile", with: ''
      fill_in "Email", with: 'braam.oosthuizen@hotmail.com'
      fill_in "Home town", with: 'Bloemfontein'
      within(:css, "#first-facility") do
        select  "Small Chalet (4 people)", from: "Facility"
      end
      find(:css, "#reservation_request_start_date_1").set('31 Jul 2018')
      find(:css, "#reservation_request_end_date_1").set('03 Aug 2018')
      find(:css, "#reservation_request_adults_18_plus_count_1").set(2)

      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("applicant_name: Please enter your name and surname")

      fill_in "Name and Surname", with: "George Labechagne"
      fill_in "Telephone", with: ''
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("applicant_telephone: At least one contact number is required")

      fill_in "Mobile", with: '112233445'
      fill_in "Email", with: 'john.hotmail.com'
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("applicant_email: is invalid")

      fill_in "Email", with: 'braam.oosthuizen@hotmail.com'
      fill_in "Home town", with: 'D'
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("applicant_town: Please enter the name of your town or city.")
    end

    scenario "Provide incorrect details for the first facility" do
      visit new_reservation_request_path
      fill_in_applicant_details
      find(:css, "#reservation_request_start_date_1").set('31 Dec 2014')
      find(:css, "#reservation_request_end_date_1").set('03 Jan 2018')
      find(:css, "#reservation_request_adults_18_plus_count_1").set(2)
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("start_date_1: Invalid arrival date")

      find(:css, "#reservation_request_start_date_1").set('31 Jul 2018')
      find(:css, "#reservation_request_end_date_1").set('03 May 2018')
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("end_date_1: Invalid departure date")

      find(:css, "#reservation_request_end_date_1").set('31 Jul 2018')
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("end_date_1: Invalid departure date")

      find(:css, "#reservation_request_end_date_1").set('11 Jul 2018')
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("end_date_1: Invalid departure date")

      find(:css, "#reservation_request_start_date_1").set('31 Jul 2018')
      find(:css, "#reservation_request_end_date_1").set('11 Aug 2018')
      find(:css, "#reservation_request_adults_18_plus_count_1").set(0)
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("adults_18_plus_count_1: Number of people is not provided")

      find(:css, "#reservation_request_infants_count_1").set(2)
      click_button "Save and Review"
      expect(page).to have_text("Reservation Enquiry contains errors")
      expect(page).to have_text("adults_18_plus_count_1: An adult is required to care for infants")

    end

  end

  private

    def fill_in_applicant_details
      fill_in "Name and Surname", with: "Braam Oosthuizen"
      fill_in "Telephone", with: '112233445'
      fill_in "Mobile", with: '112883445'
      fill_in "Email", with: 'braam.oosthuizen@hotmail.com'
      fill_in "Home town", with: 'Bloemfontein'
    end

    def verify_applicant_details_are_correct
      expect( find(:css, "input#reservation_request_applicant_name").value).to eq('Braam Oosthuizen')
      expect( find(:css, "input#reservation_request_applicant_telephone").value).to eq('112233445')
      expect( find(:css, "input#reservation_request_applicant_mobile").value).to eq('112883445')
      expect( find(:css, "input#reservation_request_applicant_email").value).to eq('braam.oosthuizen@hotmail.com')
      expect( find(:css, "input#reservation_request_applicant_town").value).to eq('Bloemfontein')
    end

    def fill_in_facility_1
      find(:css, "#reservation_request_start_date_1").set('31 Mar 2018')
      find(:css, "#reservation_request_end_date_1").set('10 Apr 2018')
      find(:css, "#reservation_request_adults_18_plus_count_1").set(2)
      find(:css, "#reservation_request_teenagers_count_1").set(2)
      find(:css, "#reservation_request_children_6_12_count_1").set(1)
      find(:css, "#reservation_request_infants_count_1").set(2)
      find(:css, "#reservation_request_power_point_required_1").set(true)
    end

    def fill_in_facility_2
      find(:css, "#reservation_request_start_date_2").set('10 Apr 2018')
      find(:css, "#reservation_request_end_date_2").set('12 Apr 2018')
      find(:css, "#reservation_request_adults_18_plus_count_2").set(2)
      find(:css, "#reservation_request_teenagers_count_2").set(3)
      find(:css, "#reservation_request_children_6_12_count_2").set(1)
      find(:css, "#reservation_request_infants_count_2").set(2)
      find(:css, "#reservation_request_power_point_required_2").set(false)
    end

    def verify_facility_1_details_are_correct
      # puts "Verifying facility 1 is correct"
      expect( ['31 Mar 2018', '31 March 2018']).to include(find(:css, "input#reservation_request_start_date_1").value)
      expect( ['10 Apr 2018', '10 April 2018']).to include(find(:css, "input#reservation_request_end_date_1").value)
      expect( find(:css, "input#reservation_request_adults_18_plus_count_1").value).to eq('2')
      expect( find(:css, "input#reservation_request_teenagers_count_1").value).to eq('2')
      expect( find(:css, "input#reservation_request_children_6_12_count_1").value).to eq('1')
      expect( find(:css, "input#reservation_request_infants_count_1").value).to eq('2')
      expect( find(:css, "input#reservation_request_power_point_required_1").checked?).to eq('checked')
    end

    def verify_facility_2_details_are_correct
      # puts "Verifying facility 2 is correct"
      expect( find(:css, "input#Second_facility_required_").value).to eq('1')
      expect( ['10 Apr 2018', '10 April 2018']).to include(find(:css, "input#reservation_request_start_date_2").value)
      expect( ['12 Apr 2018', '12 April 2018']).to include(find(:css, "input#reservation_request_end_date_2").value)
      expect( find(:css, "input#reservation_request_adults_18_plus_count_2").value).to eq('2')
      expect( find(:css, "input#reservation_request_teenagers_count_2").value).to eq('3')
      expect( find(:css, "input#reservation_request_children_6_12_count_2").value).to eq('1')
      expect( find(:css, "input#reservation_request_infants_count_2").value).to eq('2')
      expect( find(:css, "input#reservation_request_power_point_required_2").checked?).to eq(nil)
    end
end
