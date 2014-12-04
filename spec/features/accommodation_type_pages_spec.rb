require 'spec_helper'

feature "AccommodationType pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper
  include SessionsHelper

  context "Admin user create new accommodation type" do

    before do
      @admin = create(:admin)
      login @admin
    end

    scenario "Create new accommodation type" do
      visit new_admin_accommodation_type_path
      expect(page).to have_title('Create Accommodation Type')
      expect(page).to have_selector('h1', text: "Create Accommodation Type")
      expect(page).to have_text('Description')
      expect(page).to have_text('Show this type')
      expect(page).to have_text('Normal prices')
      expect(page).to have_text('In-season prices')
      expect(page).to have_text('Promotion prices')
      expect(page).to have_selector(:button, 'Create Accommodation Type')

      fill_in "Accommodation Type", with: "A"
      fill_in "Description", with: "Tent Site Without Power Points"
      find(:css, "#accommodation_type_show").set(true)
      find(:css, "#accommodation_type_show_normal_price").set(true)
      find(:css, "#accommodation_type_show_in_season_price").set(true)
      find(:css, "#accommodation_type_show_promotion").set(true)

      click_button "Create Accommodation Type" 

      expect(page).to have_text('Accommodation Type created successfully')
      expect(page).to have_title('Accommodation Type Details')
      expect(page).to have_selector('h1', text: "Accommodation Type Details")
      expect( find(:css, "input#accommodation_type_accom_type").value ).to eq('A')
      expect( find(:css, "input#accommodation_type_description").value ).to eq('Tent Site Without Power Points')
      expect( find(:css, "input#accommodation_type_show").value).to eq "1"
      expect( find(:css, "input#accommodation_type_show_normal_price").value).to eq "1"
      expect( find(:css, "input#accommodation_type_show_in_season_price").value).to eq "1"
      expect( find(:css, "input#accommodation_type_show_promotion").value).to eq "1"

      expect(page).to have_selector(:link_or_button, 'Return to Accommodation Type List')
      expect(page).to have_selector(:link_or_button, 'Edit')
    end

    scenario "Detect items on Accommodation Type List" do
      acc_type_a = create(:accommodation_type, 
          accom_type: 'A',
          description: 'Tent Site Without Power Points',
          show: true,
          show_normal_price: false,
          show_in_season_price: true,
          show_promotion: false)
      acc_type_b = create(:accommodation_type, 
          accom_type: 'B',
          description: 'Tent Site With Power Points',
          show: false,
          show_normal_price: true,
          show_in_season_price: false,
          show_promotion: true)
      visit admin_accommodation_types_path
      expect(page).to have_title('Accommodation Type List')
      expect(page).to have_selector('h1', text: "Accommodation Type List")
      expect(page).to have_text('Accommodation Type')
      expect(page).to have_text('Description')
      expect(page).to have_text('Show this type')
      expect(page).to have_text('Normal prices')
      expect(page).to have_text('In-season prices')
      expect(page).to have_text('Promotion prices')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(1)", text: 'A')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(1)", text: 'B')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(2)", text: 'Tent Site Without Power Points')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(2)", text: 'Tent Site With Power Points')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(3)", text: 'Yes')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(4)", text: 'No')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(5)", text: 'Yes')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(6)", text: 'No')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(3)", text: 'No')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(4)", text: 'Yes')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(5)", text: 'No')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(6)", text: 'Yes')
    end

    scenario "Update existing Accommodation Type" do
      acc_type_a = create(:accommodation_type, 
          accom_type: 'A',
          description: 'Tent Site Without Power Points',
          show: true,
          show_normal_price: false,
          show_in_season_price: true,
          show_promotion: false)
      puts acc_type_a.inspect
      visit edit_admin_accommodation_type_path(acc_type_a)
      expect(page).to have_title('Update Accommodation Type')
      expect(page).to have_selector('h1', text: "Update Accommodation Type")
      expect(page).to have_text('Accommodation Type')
      expect(page).to have_text('Description')
      expect(page).to have_text('Show this type')
      expect(page).to have_text('Normal prices')
      expect(page).to have_text('In-season prices')
      expect(page).to have_text('Promotion prices')
      expect( find(:css, "input#accommodation_type_accom_type").value ).to eq('A')
      expect( find(:css, "input#accommodation_type_description").value ).to eq('Tent Site Without Power Points')
      expect( find(:css, "input[name='accommodation_type[show]']:nth-child(2)").checked?).to eq("checked") 
      expect( find(:css, "input[name='accommodation_type[show_normal_price]']:nth-child(2)").checked?).to eq(nil) 
      expect( find(:css, "input[name='accommodation_type[show_in_season_price]']:nth-child(2)").checked?).to eq("checked") 
      expect( find(:css, "input[name='accommodation_type[show_promotion]']:nth-child(2)").checked?).to eq(nil) 
      expect(page).to have_selector(:link_or_button, 'Update Accommodation Type')
    end
  end

  def login(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end