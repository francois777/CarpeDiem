require 'spec_helper'

feature "CampingSite pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper
  include SessionsHelper

  context "Admin user creates camping site" do

    before do
      @admin = create(:admin)
      login(@admin)
    end

    scenario "Visit new camping site page" do
      visit new_admin_camping_site_path
      expect(page).to have_title('New Camping Site')
      expect(page).to have_selector('h1', text: "New Camping Site")
      expect(page).to have_text('Location')
      expect(page).to have_text('Camping Type')
      expect(page).to have_text('Power Points Included?')
      expect(page).to have_text('May be reserved?')
      expect(page).to have_selector(:button, 'Create Camping Site')
    end

    scenario "Create new camping site" do
      visit new_admin_camping_site_path
      choose "Tent"
      fill_in "Location", with: "T27"
      find(:css, "#camping_site_powered").set(true)
      find(:css, "#camping_site_reservable").set(true)
      click_button "Create Camping Site" 

      expect(page).to have_text('Camping Site created successfully')
      expect(page).to have_title('Camping Site Details')
      expect(page).to have_selector('h1', text: "Camping Site Details")
    end
  end

  context "Admin user updates camping site" do

    before do
      @admin = create(:admin)
      login(@admin)
      @camping_site = create(:camping_site)
    end

    scenario "Visit edit camping site page" do
      visit edit_admin_camping_site_path(@camping_site)
      expect(page).to have_title('Update Camping Site')
      expect(page).to have_selector('h1', text: "Update Camping Site")
      expect(page).to have_text('Camping Type')
      expect(page).to have_text('Location')
      expect(page).to have_text('Power Points Included?')
      expect(page).to have_text('May be reserved?')
      expect(page).to have_selector(:button, 'Update Camping Site')

      choose "Tent"
      fill_in "Location", with: "T100"
      find(:css, "#camping_site_powered").set(false)
      find(:css, "#camping_site_reservable").set(false)
      click_button "Update Camping Site" 

      expect(page).to have_text('Camping Site updated successfully')
      expect(page).to have_title('Camping Site Details')
      expect(page).to have_selector('h1', text: "Camping Site Details")
      # expect( find(:css, "input#camping_site_camping_type").value).to eq('Tent')
      expect( find(:css, "input#camping_site_location_code").value).to eq('T100')
      expect( find(:css, "input#camping_site_powered").checked?).to eq(nil)
      expect( find(:css, "input#camping_site_reservable").checked?).to eq(nil)
    end
  end


  def login(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

end
