#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environment'
require 'haml'
require 'sass'

configure do
  set :haml, { :format => :html5 }
end

get '/styles/:file.css' do
  scss params[:file].to_sym
end

get '/' do
  haml :index
end
