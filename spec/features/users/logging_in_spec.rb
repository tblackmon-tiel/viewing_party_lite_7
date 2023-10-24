require 'rails_helper'

RSpec.describe "Logging In", type: :feature do
  describe "when logged in" do
    before(:each) do
      @user1 = User.create!(name: "Kiwi", email: "kiwibird@gmail.com", password: "123pass", password_confirmation: "123pass")
      @user2 = User.create!(name: "Chicken", email: "chickenbird@gmail.com", password: "123pass", password_confirmation: "123pass")
      @user3 = User.create!(name: "Coco", email: "cocobird@gmail.com", password: "123pass", password_confirmation: "123pass")

      visit login_path

      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password
      click_button "Log In"
    end

    it "I no longer see a link to login or create an account on the landing page, but see a link to log out" do
      visit root_path

      expect(page).to have_content("Log Out")
      expect(page).to_not have_content("Log In")
      expect(page).to_not have_content("Create an Account")
    end

    it "I see a list of all users emails on the welcome page" do
      visit root_path

      expect(page).to have_content(@user2.email)
      expect(page).to have_content(@user3.email)
    end
  end
end
