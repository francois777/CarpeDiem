require 'spec_helper'

feature "Tariff pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper

  context "Admin user create new tariff" do

    before do
      @admin = create(:user)
    end

    scenario "Visit new tariff page" do
      sign_in(@admin)
      visit new_admin_tariff_path
      expect(page).to have_selector('h1', text: "Create Tariff")
      options = {}
      options['Caravan Site per Person, Without Power Points, Out of Season'] = 'C1'
      options['Day Visitor per person, Out of Season'] = 'E1'
      options['Group Tariff Meals Included, per person, per weekend'] = 'H3'
      expect(page).to have_text('Tariff Category')
      expect(page).to have_text('Effective Date')
      expect(page).to have_text('End Date')
      expect(page).to have_selector('input[type=submit][value="Create Tariff"]')
    end

    scenario "Ensure currency conversions are correct" do
      expect(to_base_amount(90.50)).to eq(9050)
      expect(to_local_amount(9050)).to eq('90.50')
      expect(to_local_currency(9050)).to eq('R 90.50')
    end

  end
end