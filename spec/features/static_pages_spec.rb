require 'spec_helper.rb'

feature "Statis pages" do

  context "Home Page" do


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