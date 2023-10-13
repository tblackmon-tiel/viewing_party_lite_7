require "rails_helper"

RSpec.describe Party, type: :model do
  describe "relationships" do
    it {should have_many(:party_users)}
    it {should have_many(:users).through(:party_users)}
  end

  describe "validations" do
    it {should validate_presence_of :movie_id}
    it {should validate_presence_of :date}
    it {should validate_presence_of :start_time}
  end

  describe "instance methods" do
    before(:each) do
      @user_1 = User.create!(name: "Kiwi", email: "kiwibird@gmail.com")
      @user_2 = User.create!(name: "Chicken", email: "chickenbird@gmail.com")
      @party_1 = Party.create!(movie_id: 926393, duration: 109, date: "2024-10-10", start_time: "07:23")
      PartyUser.create!(user_id: @user_1.id, party_id: @party_1.id, is_host: true)
      PartyUser.create!(user_id: @user_2.id, party_id: @party_1.id, is_host: false)
    end

    describe "#get_host" do
      it "returns the name of the party's host" do
        expect(@party_1.get_host_name).to eq(@user_1.name)
      end
    end
  end
end