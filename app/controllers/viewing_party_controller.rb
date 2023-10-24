# frozen_string_literal: true

class ViewingPartyController < ApplicationController
  def new
    if session[:user_id]
      @facade = ViewingPartyFacade.new(params[:movie_id], params[:user_id])
    else
      flash[:error] = "You must be logged in to create a viewing party!"
      redirect_to user_movie_path(params[:user_id], params[:movie_id])
    end
  end

  def create
    party = Party.new(party_params)
    if party.save
      guest_list = [params[:user_id].to_i]
      params.select { |key, value| key.include?('invite') && value == '1' }
            .each_key { |key| guest_list << key.gsub('invite-', '').to_i }
  
      guest_list.each do |guest_id|
        PartyUser.create(user_id: guest_id, party_id: party.id, is_host: guest_id == params[:user_id].to_i)
      end
  
      redirect_to user_path(params[:user_id])
    else
      flash[:error] = "Please fill out the entire form!"
      redirect_to new_user_movie_viewing_party_path(params[:user_id], params[:movie_id])
    end
  end

  private

  def party_params
    params.permit(:movie_id, :date, :start_time, :duration)
  end
end
