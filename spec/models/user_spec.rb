# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many(:party_users) }
    it { should have_many(:parties).through(:party_users) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
    it { should have_secure_password }
  end

  describe 'class methods' do
    describe '#all_excluding_id' do
      it 'returns all users excluding the ID provided' do
        @user_1 = User.create!(name: 'Kiwi', email: 'kiwibird@gmail.com', password: 'test')
        @user_2 = User.create!(name: 'Coco', email: 'cocobird@gmail.com', password: 'test')
        @user_3 = User.create!(name: 'Chicken', email: 'chickenbird@gmail.com', password: 'test')
        @user_4 = User.create!(name: 'Hiccup', email: 'hiccupbird@gmail.com', password: 'test')

        expect(User.all_excluding_id(@user_1.id)).to eq([@user_2, @user_3, @user_4])
        expect(User.all_excluding_id(@user_3.id)).to eq([@user_1, @user_2, @user_4])
      end
    end
  end

  describe 'instance methods' do
    before(:each) do
      @user_1 = User.create!(name: 'Kiwi', email: 'kiwibird@gmail.com', password: 'test')
      @user_2 = User.create!(name: 'Chicken', email: 'chickenbird@gmail.com', password: 'test')
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
    end

    describe '#hosted_parties' do
      it 'returns all parties where the user is a host' do
        expect(@user_1.hosted_parties).to eq([@party_1])
      end
    end

    describe '#invited_parties' do
      it 'returns all parties where the user is a guest' do
        expect(@user_1.invited_parties).to eq([@party_2, @party_3])
      end
    end
  end
end
