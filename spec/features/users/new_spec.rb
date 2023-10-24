# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration Form' do
  describe "when I visit '/register'" do
    it 'has a form to create a new user' do
      visit root_path
      click_on 'Create an Account'
      expect(current_path).to eq(register_path)
      expect(page).to have_content('Register a New User')
      expect(page).to have_field('user_name')
      expect(page).to have_field('user_email')
      expect(page).to have_field('user_password')
      expect(page).to have_field('user_password_confirmation')
      expect(page).to have_button('Create User')
    end

    it 'redirects to the dashboard page `/users/:id`' do
      visit register_path
      fill_in('user_name', with: 'Marge')
      fill_in('user_email', with: 'marge@email.com')
      fill_in('user_password', with: '123pass')
      fill_in('user_password_confirmation', with: '123pass')

      click_button('Create User')

      expect(current_path).to eq(user_path(User.last))
      expect(page).to have_content("Marge's Dashboard")
    end

    it 'If name is blank, I see an error' do
      visit register_path
      fill_in('Name', with: '')
      fill_in('Email', with: 'NameLast@gmail.com')
      fill_in('user_password', with: '123pass')
      fill_in('user_password_confirmation', with: '123pass')

      click_button('Create User')

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Name can't be blank")
    end

    it 'If email is blank, I see an error' do
      visit register_path
      fill_in('Name', with: 'Name')
      fill_in('Email', with: '')
      fill_in('user_password', with: '123pass')
      fill_in('user_password_confirmation', with: '123pass')

      click_button('Create User')

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Email can't be blank")
    end

    it "If password is blank, I see an error" do
      visit register_path
      fill_in('Name', with: 'Name')
      fill_in('Email', with: 'name@gmail.com')
      fill_in('user_password', with: '')

      click_button('Create User')

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Password can't be blank")
    end

    it "If password and password confirmation don't match, I see an error" do
      visit register_path
      fill_in('Name', with: 'Name')
      fill_in('Email', with: 'name@gmail.com')
      fill_in('user_password', with: '123pass')
      fill_in('user_password_confirmation', with: '1234pass')

      click_button('Create User')

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
