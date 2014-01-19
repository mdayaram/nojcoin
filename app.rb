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
