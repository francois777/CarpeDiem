require 'spec_helper'

feature "Chalet pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper
  include SessionsHelper

  context "Admin user create chalets" do

    before do
      @admin = create(:admin)
      login(@admin)
    end

    scenario "Visit new chalet page" do
      visit new_admin_chalet_path
      expect(page).to have_title('New Chalet')
      expect(page).to have_selector('h1', text: "New Chalet")
      expect(page).to have_text('Name')
      expect(page).to have_text('Location')
      expect(page).to have_text('Style Class')
      expect(page).to have_text('Reservable')
      expect(page).to have_text('Inauguration Date')
      expect(page).to have_selector(:button, 'Create Chalet')
    end

    scenario "Create new chalet" do
      visit new_admin_chalet_path
      select  "Asher", from: "Name"
      fill_in "Location", with: "A07"
      select  "Luxury", from: "Style Class"
      find(:css, "#chalet_reservable").set(true)
      fill_in "Inauguration Date", with: "31/03/2015"
      click_button "Create Chalet" 

      expect(page).to have_text('Chalet created successfully')
      expect(page).to have_title('Chalet Details')
      expect(page).to have_selector('h1', text: "Chalet Details")
    end
  end

  context "Admin user updates chalet" do

    before do
      @admin = create(:admin)
      login(@admin)
      @chalet = create(:chalet)
    end

    scenario "Visit edit chalet page" do
      visit edit_admin_chalet_path(@chalet)
      expect(page).to have_title('Update Chalet')
      expect(page).to have_selector('h1', text: "Update Chalet")
      expect(page).to have_text('Name')
      expect(page).to have_text('Location')
      expect(page).to have_text('Style Class')
      expect(page).to have_text('Reservable?')
      expect(page).to have_text('Inauguration Date')
      expect(page).to have_selector(:button, 'Update Chalet')

      select  "Benjamin", from: "Name"
      fill_in "Location", with: "A12"
      select  "Basic", from: "Style Class"
      find(:css, "#chalet_reservable").set(false)
      fill_in "Inauguration Date", with: "31/01/2015"
      click_button "Update Chalet" 

      expect(page).to have_text('Chalet updated successfully')
      expect(page).to have_title('Chalet Details')
      expect(page).to have_selector('h1', text: "Chalet Details")

      expect( find(:css, "input#chalet_name").value).to eq('Benjamin')
      expect( find(:css, "input#chalet_location_code").value).to eq('A12')
      expect( find(:css, "input#chalet_style_class").value).to eq('Basic')
      expect( find(:css, "input#chalet_reservable").checked?).to eq(nil)
      expect( find(:css, "input#chalet_inauguration_date").value).to eq(display_date(Date.new(2015,1,31)))
      expect( find(:css, "textarea#chalet_name_definition").value).to eq('The definition of the name of Benjamin')
    end

  end

  context "Admin user views chalets" do

    before do
      @admin = create(:admin)
      login(@admin)
    end

    scenario "View single chalet" do
      chalet = create(:chalet)
      visit admin_chalet_path(chalet)

      expect(page).to have_title('Chalet Details')
      expect(page).to have_selector('h1', text: "Chalet Details")
      expect(page).to have_text('Name')
      expect(page).to have_text('Location')
      expect(page).to have_text('Style Class')
      expect(page).to have_text('Reservable')
      expect(page).to have_text('Inauguration Date')
      expect(page).to have_text('Name Definition')

      expect( find(:css, "input#chalet_name").value).to eq('Simeon')
      expect( find(:css, "input#chalet_location_code").value).to eq('A12')
      expect( find(:css, "input#chalet_style_class").value).to eq('Standard')
      expect( find(:css, "input#chalet_reservable").value).to eq('1')
      expect( find(:css, "input#chalet_inauguration_date").value).to eq(display_date(chalet.inauguration_date))
      expect( find(:css, "textarea#chalet_name_definition").value).to eq('The definition of the name of Simeon')
      expect(page).to have_selector(:button, 'Edit')
      click_button "Edit" 

      expect(page).to have_text('Chalet Details')
      expect(page).to have_title('Chalet Details')
      expect(page).to have_selector('h1', text: "Chalet Details")

    end

    scenario "View list of chalets" do
      chalet1 = create(:chalet, name: 'Judah', location_code: 'A1', style_class: 2)
      chalet2 = create(:chalet, name: 'Dan', location_code: 'A2', style_class: 1)
      chalet3 = create(:chalet, name: 'Joseph', location_code: 'A3', style_class: 2)
      visit admin_chalets_path
      expect(page).to have_title('Chalet List')
      expect(page).to have_selector('h1', text: "Chalet List")
      expect(page).to have_text('Name')
      expect(page).to have_text('Location')
      expect(page).to have_text('Style Class')
      expect(page).to have_text('Reservable')

      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(1)", text: 'Judah')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(2)", text: 'A1')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(3)", text: 'Luxury')
      expect(page).to have_selector("table tbody tr:nth-of-type(1) td:nth-of-type(4)", text: 'Yes')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(1)", text: 'Dan')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(2)", text: 'A2')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(3)", text: 'Standard')
      expect(page).to have_selector("table tbody tr:nth-of-type(2) td:nth-of-type(4)", text: 'Yes')
      expect(page).to have_selector("table tbody tr:nth-of-type(3) td:nth-of-type(1)", text: 'Joseph')
      expect(page).to have_selector("table tbody tr:nth-of-type(3) td:nth-of-type(2)", text: 'A3')
      expect(page).to have_selector("table tbody tr:nth-of-type(3) td:nth-of-type(3)", text: 'Luxury')
      expect(page).to have_selector("table tbody tr:nth-of-type(3) td:nth-of-type(4)", text: 'Yes')
      expect(page).to have_selector(:button, 'Add Chalet')

    end

  end

  def login(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

end