require 'spec_helper.rb'

feature "Statis pages" do

  context "Home Page" do

    scenario "All menu options are present" do
      visit '/'
      # expect(page).to have_link('Home')
      expect(page).to have_css('a', 'Home')
      expect(page).to have_css('a', 'Accomodation')
      expect(page).to have_css('a', 'Activities')
      expect(page).to have_css('a', 'Facilities')
      expect(page).to have_css('a', 'Menu')
      expect(page).to have_css('a', 'Visit us')
      expect(page).to have_css('a', 'Bookings')
      expect(page).to have_css('a', 'Tariffs')
      expect(page).to have_css('a', 'Make reservation')
      expect(page).to have_css('a', 'What will you see?')
      expect(page).to have_css('a', 'About us')
      expect(page).to have_css('a', 'Contact us')
      expect(page).to have_css('a', 'Where are we?')
    end

    scenario "Static text is shown on page" do
      visit '/'
      expect(page).to have_selector('h2', 'Camping grounds')
      expect(page).to have_text('THIS IS THE DAY')
      expect(page).to have_selector('h2', 'Carpe Diem - Hekpoort')
      expect(page).to have_text('is in Hekpoort')
      expect(page).to have_text('Jacques and Henriëtte Kotzé')
      expect(page).to have_text('Francois van der Hoven')
    end
  end
end