#!/usr/bin/env ruby

require_relative './config/environment'
require_relative './models/trade'

get '/styles/:file.css' do
  scss params[:file].to_sym
end

get '/' do
  trade = Trade.order("created_at DESC").first
  @owner = trade.to
  @value = trade.offer
  @notes = trade.notes
  haml :index
end

get '/about' do
  haml :about
end

get '/who' do
  @who = params[:is]
  haml :who
end

get '/sad' do
  @sad = params[:person]
  haml :sad
end

get '/stolen/:id' do
  @trade = Trade.find(params[:id])
  haml :stolen
end

get '/mine' do
  @trade = Trade.order("created_at DESC").first
  @trade.offer ||= 0
  @trade.offer = @trade.offer.to_i + 1
  @trade.save!
  haml :mine
end

get '/steal' do
  trade = Trade.order("created_at DESC").first
  @owner = trade.to
  haml :steal
end

post '/steal' do
  stealer = twotter? params[:stealer]
  if stealer.nil?
    redirect "/who?is=#{params[:stealer]}"
  end

  last = Trade.order("created_at DESC").first

  if stealer == last.to
    redirect "/sad?person=#{stealer}"
  end

  @trade = Trade.new
  @trade.to = stealer
  @trade.from = last.to
  @trade.offer = last.offer
  @trade.notes = "burn!"

  if @trade.save
    tweet "Oh no! #{@trade.to} just stole me from #{@trade.from}!"
    redirect "/stolen/#{@trade.id}"
  else
    haml :steal
  end
end
