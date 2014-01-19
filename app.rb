#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require 'sass'
require_relative './config/environment'
require_relative './models/trade'

configure do
  set :haml, { :format => :html5 }
end

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
