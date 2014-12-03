require 'spec_helper.rb'

feature "Application pages" do

  context "The application is language-sensitive" do

    scenario "detect that browser language has changed and switch to that language" do
      I18n.locale = 'en'
      visit root_path
      expect(page).to have_selector('h2', text: "Camping grounds")
      I18n.locale = 'af'
      visit root_path
      expect(page).to have_selector('h2', text: "Kampterrein")
      I18n.locale = 'en'
    end
  end

  context "Headers and footers display necessary text and links" do

    scenario "Visiting user looks at menu and footer" do
      visit '/'
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
  end

end 