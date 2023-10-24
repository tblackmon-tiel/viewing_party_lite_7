# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Viewing Party New page', type: :feature do
  describe 'when I visit the viewing party new page' do
    before(:each) do
      @user_1 = User.create!(name: 'Kiwi', email: 'kiwibird@gmail.com', password: "123pass")
      @user_2 = User.create!(name: 'Chicken', email: 'chickenbird@gmail.com', password: "123pass")
      @user_3 = User.create!(name: 'Coco', email: 'cocobird@gmail.com', password: "123pass")
      @user_4 = User.create!(name: 'Hiccup', email: 'hiccupbird@gmail.com', password: "123pass")
      @movie_id = 926_393

      json_response = File.read('spec/fixtures/movie_details.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}?api_key=#{Rails.application.credentials.tmdb[:key]}")
        .to_return(status: 200, body: json_response)

      visit login_path
      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_button "Log In"

      visit new_user_movie_viewing_party_path(@user_1.id, @movie_id)
    end

    it 'I should see the name of the movie title' do
      expect(page).to have_content('The Equalizer 3')
    end

    it 'I should see a form below the movie title with the duration, when, start time, and checkboxes for each existing system user' do
      expect(page.has_field?('duration')).to be true
      expect(page.has_field?('date')).to be true
      expect(page.has_field?('start_time')).to be true
      expect(page.has_unchecked_field?("invite-#{@user_2.id}")).to be true
      expect(page.has_unchecked_field?("invite-#{@user_3.id}")).to be true
      expect(page.has_unchecked_field?("invite-#{@user_4.id}")).to be true
    end

    it 'The duration should default the value of the movie runtime in minutes' do
      expect(page).to have_field('duration', with: 109)
    end

    it 'Should create a new viewing party and redirect the user to their dashboard on submit' do
      fill_in 'date', with: '2023-10-10'
      fill_in 'start_time', with: '01:47:01'
      click_button 'Create Viewing Party'

      expect(page).to have_current_path(user_path(@user_1.id))
      expect(Party.last.start_time.strftime('%H:%M:%S')).to eq('01:47:01')
    end

    it 'Should create any associated invitations for a viewing party when the form is submitted' do
      fill_in 'date', with: '2023-10-10'
      fill_in 'start_time', with: '01:47:01'
      check "invite-#{@user_2.id}"
      click_button 'Create Viewing Party'

      expect(page).to have_current_path(user_path(@user_1.id))
      expect(PartyUser.last.user_id).to eq(@user_2.id)
      expect(PartyUser.last.is_host).to be false
    end

    it 'Should exclude the current user from the invitees list' do
      expect(page).to have_css("#invite-#{@user_2.id}")
      expect(page).to have_css("#invite-#{@user_3.id}")
      expect(page).to have_css("#invite-#{@user_4.id}")
      expect(page).to_not have_css("#invite-#{@user_1.id}")
    end

    it "Should throw an error if the form is not filled out completely" do
      fill_in 'date', with: '2023-10-10'
      click_button 'Create Viewing Party'

      expect(page).to have_current_path(new_user_movie_viewing_party_path(@user_1.id, @movie_id))
      expect(page).to have_content("Please fill out the entire form!")
    end

    it "Should return the user to the movies show page and provide an error if they're not logged in" do
      json_response = File.read('spec/fixtures/movie_credits.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}/credits?api_key=#{Rails.application.credentials.tmdb[:key]}")
        .to_return(status: 200, body: json_response)

      json_response = File.read('spec/fixtures/movie_reviews.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/#{@movie_id}/reviews?api_key=#{Rails.application.credentials.tmdb[:key]}")
        .to_return(status: 200, body: json_response)
        
      visit root_path
      click_link "Log Out"

      visit new_user_movie_viewing_party_path(@user_1.id, @movie_id)
      expect(page).to have_current_path(user_movie_path(@user_1.id, @movie_id))
    end
  end
end
