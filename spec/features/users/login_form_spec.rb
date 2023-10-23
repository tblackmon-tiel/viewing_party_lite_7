require 'rails_helper'

RSpec.describe "User Login", type: :feature do
  describe "When visiting /login," do
    it "I see a form to login using my email and password" do
      visit login_path

      expect(page).to have_field("email")
      expect(page).to have_field("password")

      expect(page).to have_button("Log In")
    end

    it "logs me in successfully if I provide a correct email and password" do
      user = User.create!(name: "Kiwi", email: "kiwibird@gmail.com", password: "123pass")
      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Log In"

      expect(current_path).to eq(user_path(user))
    end

    it "throws an error if my credentials are bad" do
      user = User.create!(name: "Kiwi", email: "kiwibird@gmail.com", password: "123pass")
      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: "Incorrect"
      click_button "Log In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Sorry, your credentials are incorrect!")
    end
  end
end