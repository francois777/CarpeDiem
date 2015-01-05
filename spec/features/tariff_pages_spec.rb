require 'spec_helper'
# require 'sessions_helper'

feature "Tariff pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper
  include SessionsHelper

  context "Admin user create new tariff" do

    before do
      @accommodation_type = create(:accommodation_type)
      @admin = create(:admin)
      login @admin
    end

    scenario "Create new tariff" do
      visit new_admin_accommodation_type_tariff_path(@accommodation_type)
      expect(page).to have_title('New Tariff')

      expect(page).to have_selector('h1', text: "New Tariff")
      options = {}
      options['Caravan Site per Person, Without Power Points, Out of Season'] = 'C1'
      options['Day Visitor per person, Out of Season'] = 'E1'
      options['Group Tariff Meals Included, per person, per weekend'] = 'H3'
      expect(page).to have_text('Tariff Category')
      expect(page).to have_text('Effective Date')
      expect(page).to have_selector(:button, 'Create Tariff')

      select "Chalet Large, Promotion", from: "Tariff Category"
      fill_in "Tariff", with: "55.9"
      fill_in "Effective Date", with: "31/07/2015"
      click_button "Create Tariff" 

      expect(page).to have_text('Tariff created successfully')
      expect(page).to have_title('Tariff Details')
      expect(page).to have_selector('h1', text: "Tariff Details")
      expect( find(:css, "input#tariff_tariff_category").value ).to eq('Chalet Large, Promotion')
      expect( find(:css, "input#tariff_tariff").value ).to eq('R 55.90')
      expect( find(:css, "input#tariff_effective_date").value ).to eq('31 July 2015')

      expect(page).to have_selector(:link_or_button, 'Return to Tariff List')
    end

    scenario "Detect items on Tariff List" do

      catc1 = create(:tariff, tariff_category: 'C1', tariff: 9999, 
                              effective_date: Date.new(2015,02,28),
                              end_date: nil,
                              accommodation_type: @accommodation_type)
      catc2 = create(:tariff, tariff_category: 'C2', tariff: 8800, 
                              effective_date: Date.new(2015,03,01),
                              end_date: nil,
                              accommodation_type: @accommodation_type)
      visit admin_accommodation_type_tariffs_path(@accommodation_type)
      expect(page).to have_title('Tariff List')
      expect(page).to have_selector('h1', text: "Tariff List")
      expect(page).to have_text('Tariff Category')
      expect(page).to have_text('Tariff')
      expect(page).to have_text('Effective Date')
      expect(page).to have_text('End Date')
      expect(page).to have_text('Caravan Site per Person, Without Power Points, Out of Season')
      expect(page).to have_text('Caravan Site per Person, Without Power Points, In Season')
      expect(page).to have_text('R 99.99')
      expect(page).to have_text(String.new('28/02/2015'))
      expect(page).to have_text('R 88.00')
      expect(page).to have_text(String.new('01/03/2015'))
      expect(page).to have_selector(:link_or_button, 'Add Tariff')
    end

    scenario "Replace a tariff with a new price" do

      catc1 = create(:tariff, tariff_category: 'C1', tariff: 9999, 
                              effective_date: Date.new(2015,02,28),
                              end_date: nil,
                              accommodation_type: @accommodation_type)
      visit admin_accommodation_type_tariffs_path(@accommodation_type)
      expect(page).to have_title('Tariff List')
      click_link "Add Tariff"
      select "Caravan Site per Person, Without Power Points, Out of Season", from: "Tariff Category"
      select "Normal price", from: "Price Class"
      fill_in "Tariff", with: "65.00"
      fill_in "Effective Date", with: "15/08/2015"
      click_button "Create Tariff"
      expect(page).to have_text('Tariff created successfully')
      click_link 'Return to Tariff List'
      expect(page).to have_title('Tariff List')
      expect(page).to have_text('Caravan Site per Person, Without Power Points, Out of Season')
      expect(page).to have_text('R 65.00')
      expect(page).to have_text('15/08/2015')


    end  

    # scenario "Update existing tariff" do
    #   cat_e1 = create(:tariff, tariff_category: 'E1', 
    #                            tariff: 9999, 
    #                            effective_date: Date.new(2015,02,28),
    #                            end_date: Date.new(2015,12,31),
    #                            accommodation_type: @accommodation_type)
    #   visit edit_admin_accommodation_type_tariff_path(@accommodation_type, cat_e1)
    #   expect(page).to have_title('Update Tariff')
    #   expect(page).to have_selector('h1', text: "Update Tariff")
    #   expect(page).to have_text('Tariff Category')
    #   expect(page).to have_text('Tariff')
    #   expect(page).to have_text('Effective Date')
    #   expect(page).to have_text('End Date')
    #   expect( find(:css, "input#tariff_tariff").value ).to eq('99.99')
    #   expect( find(:css, "input#tariff_effective_date").value ).to eq(String.new('2015-02-28'))
    #   expect( find(:css, "input#tariff_end_date").value ).to eq(String.new('2015-12-31'))
    #   expect(page).to have_selector('select#tariff_tariff_category') do |content|
    #     expect(content).to have_selector(:option, value = 'C1')
    #   end
    #   expect(page).to have_selector(:link_or_button, 'Update Tariff')

    #   click_button 'Update Tariff'
    # end

    scenario "Ensure currency conversions are correct" do
      expect(to_base_amount(90.50)).to eq(9050)
      expect(to_local_amount(9050)).to eq('90.50')
      expect(to_local_currency(9050)).to eq('R 90.50')
    end

  end

  def login(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

end