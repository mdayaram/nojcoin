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

get '/stolen/:id' do
  @trade = Trade.find(params[:id])
  haml :stolen
end

get '/steal' do
  trade = Trade.order("created_at DESC").first
  @owner = trade.to
  haml :steal
end

post '/steal' do
  last = Trade.order("created_at DESC").first
  @trade = Trade.new
  @trade.to = params[:stealer]
  @trade.from = last.to
  @trade.offer = last.offer
  @trade.notes = "burn!"

  if @trade.save
    redirect "/stolen/#{@trade.id}"
  else
    haml :steal
  end
end
