require 'rails_helper'

RSpec.describe "Logging In", type: :feature do
  describe "when logged in" do
    it "I no longer see a link to login or create an account on the landing page, but see a link to log out" do
      user = User.create!(name: "Kiwi", email: "kiwibird@gmail.com", password: "123pass", password_confirmation: "123pass")

      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Log In"

      visit root_path

      expect(page).to have_content("Log Out")
      expect(page).to_not have_content("Log In")
      expect(page).to_not have_content("Create an Account")
    end
  end
end
