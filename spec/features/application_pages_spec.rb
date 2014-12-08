require 'spec_helper.rb'

feature "Application pages" do

  include FactoryGirl::Syntax::Methods

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
      expect(page).to have_link('Accommodation')
      expect(page).to have_link('Activities')
      expect(page).to have_link('Facilities')
      expect(page).to have_link('Menu')
      expect(page).to have_link('Visit us')
      expect(page).to have_link('Reservations')
      expect(page).to have_link('Tariffs')
      expect(page).to have_link('Make reservation')
      expect(page).to have_link('Things to see')
      expect(page).to have_link('About us')
      expect(page).to have_link('Contact us')
      expect(page).to have_link('Where are we?')
      expect(page).to have_link('Sign in')
      expect(page).to have_text('Copyright 2014 Francois van der Hoven')
    end

    scenario "Signed in user looks at menu and footer" do
      admin = create(:user)
      visit root_path
      click_link "Sign in"
      fill_in "Email", with: admin.email
      fill_in "Password", with: "foobar"
      click_button "Sign in"
      expect(page).to have_link('Tariffs')
      expect(page).to have_text(admin.full_name)
      expect(page).to have_link('Things to see')
      expect(page).to have_link('About us')
    end
  end

end 