require 'spec_helper.rb'

feature "Application pages" do

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