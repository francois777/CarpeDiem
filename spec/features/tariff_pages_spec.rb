require 'spec_helper'

feature "Tariff pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper

  context "Admin user create new tariff" do

    before do
      @admin = create(:user)
    end

    scenario "Create new tariff" do
      sign_in(@admin)
      visit new_admin_tariff_path
      expect(page).to have_title('New Tariff')
      expect(page).to have_selector('h1', text: "Create Tariff")
      options = {}
      options['Caravan Site per Person, Without Power Points, Out of Season'] = 'C1'
      options['Day Visitor per person, Out of Season'] = 'E1'
      options['Group Tariff Meals Included, per person, per weekend'] = 'H3'
      expect(page).to have_text('Tariff Category')
      expect(page).to have_text('Effective Date')
      expect(page).to have_text('End Date')
      expect(page).to have_selector('input[type=submit][value="Create Tariff"]')

      select "Chalet Luxury, Promotion", from: "Tariff Category"
      fill_in "Tariff", with: "55.9"
      fill_in "Effective Date", with: "31/07/2015"
      fill_in "End Date", with: "01/03/2016"
      click_button "Create Tariff" 

      expect(page).to have_text('Tariff created successfully')
      expect(page).to have_title('Tariff Details')
      expect(page).to have_selector('h1', text: "Tariff Details")
      expect( find(:css, "input#tariff_tariff_category").value ).to eq('Chalet Luxury, Promotion')
      expect( find(:css, "input#tariff_tariff").value ).to eq('R 55.90')
      expect( find(:css, "input#tariff_effective_date").value ).to eq('31 July 2015')
      expect( find(:css, "input#tariff_end_date").value ).to eq('01 March 2015')
    end

    scenario "Ensure currency conversions are correct" do
      expect(to_base_amount(90.50)).to eq(9050)
      expect(to_local_amount(9050)).to eq('90.50')
      expect(to_local_currency(9050)).to eq('R 90.50')
    end

  end
end