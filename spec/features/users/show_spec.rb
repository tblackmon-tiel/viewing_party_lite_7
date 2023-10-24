# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users Show page', type: :feature do
  describe 'When I visit the users show page' do
    before(:each) do
      @user_1 = User.create!(name: 'Kiwi', email: 'kiwibird@gmail.com', password: "123pass")
      @user_2 = User.create!(name: 'Chicken', email: 'chickenbird@gmail.com', password: "123pass")
      @party_1 = Party.create!(movie_id: 926_393, duration: 109, date: '2024-10-10', start_time: '07:23')
      @party_2 = Party.create!(movie_id: 926_393, duration: 109, date: '2024-10-11', start_time: '09:23')
      @party_3 = Party.create!(movie_id: 926_393, duration: 109, date: '2024-10-12', start_time: '13:09')
      @party_4 = Party.create!(movie_id: 926_393, duration: 109, date: '2024-10-13', start_time: '15:09')
      PartyUser.create!(user_id: @user_1.id, party_id: @party_1.id, is_host: true)
      PartyUser.create!(user_id: @user_2.id, party_id: @party_1.id, is_host: false)
      PartyUser.create!(user_id: @user_1.id, party_id: @party_2.id, is_host: false)
      PartyUser.create!(user_id: @user_2.id, party_id: @party_2.id, is_host: true)
      PartyUser.create!(user_id: @user_1.id, party_id: @party_3.id, is_host: false)
      PartyUser.create!(user_id: @user_2.id, party_id: @party_3.id, is_host: true)

      visit login_path
      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_button "Log In"

      visit "/users/#{@user_1.id}"
    end

    it 'I see the page title' do
      expect(page).to have_content("#{@user_1.name}'s Dashboard")
    end

    it 'has a button to discover movies' do
      expect(page).to have_link('Discover Movies')

      click_link('Discover Movies')
      expect(page).to have_current_path("/users/#{@user_1.id}/discover")
    end

    it 'has a section for viewing parties' do
      expect(page).to have_css('#hosted-parties')
    end

    it 'returns the user to the landing page if they are not logged in' do
      visit root_path
      click_link "Log Out"

      visit dashboard_path
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("You must be logged in to view your dashboard!")
    end

    context 'displaying viewing parties' do
      it 'displays cards for each viewing party the user has created' do
        within("#party-#{@party_1.id}") do
          page.has_css?("img[src*='themoviedb']")
          expect(page).to have_content('The Equalizer 3')
          expect(page).to have_content('Oct 10, 2024')
          expect(page).to have_content('07:23 AM')
          expect(page).to have_content("Host: #{@user_1.name}")
          expect(page).to have_content("Guest List: #{@user_2.name}")
        end
      end

      it 'displays cards for each viewing party the user has been invited to' do
        within("#party-#{@party_2.id}") do
          page.has_css?("img[src*='themoviedb']")
          expect(page).to have_content('The Equalizer 3')
          expect(page).to have_content('09:23 AM')
          expect(page).to have_content("Guest List: #{@user_1.name}")
        end

        within("#party-#{@party_3.id}") do
          page.has_css?("img[src*='themoviedb']")
          expect(page).to have_content('The Equalizer 3')
          expect(page).to have_content('01:09 PM')
          expect(page).to have_content("Guest List: #{@user_1.name}")
        end
      end
    end
  end
end
