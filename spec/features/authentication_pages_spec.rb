require 'spec_helper'

feature "Authentication pages" do

  include FactoryGirl::Syntax::Methods
  include ApplicationHelper

  scenario "signin page" do
    visit signin_path

    expect(page).to have_title('Sign in')
    expect(page).to have_text('Sign in')
  end

  context "signing in" do

    scenario "signin with invalid information" do
      visit signin_path
      click_button "Sign in"

      expect(page).to have_text('Invalid')

      click_link "Home"
      expect(page).not_to have_selector('div.alert.alert-error')
    end

    scenario "normal user signs in with invalid password" do
      user = create(:user)
      visit signin_path
      fill_in "Email", with: user.email
      fill_in "Password", with: 'invalid'
      click_button "Sign in"
      expect(page).to have_text('Invalid email/password combination')
    end

    scenario "normal user signs in with valid information" do

      user = create(:user)
      puts "Test: about to sign_in user"
      sign_in user

      expect(page).to have_title(user.full_name)
      expect(page).to have_css('a', 'Sign out')

      click_link "Sign out"
      expect(page).to have_css('a', 'Sign in')
    end    

    scenario "admin user signs in with valid information" do
      admin_user = create(:admin)
      sign_in admin_user

      expect(page).to have_title(admin_user.full_name)
      expect(page).to have_link('Sign out', href: signout_path)
      expect(page).not_to have_link('Sign in', href: signin_path)

      click_link "Sign out"
      expect(page).to have_link('Sign in')
    end
  end

end